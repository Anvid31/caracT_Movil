# Sistema de Sincronización Automática con Envío por Email

## Descripción General

El sistema de sincronización automática ha sido actualizado para incluir el envío real por correo electrónico. Cuando el usuario completa una encuesta, el sistema:

1. **Programa la encuesta** para envío automático
2. **Monitorea la conectividad** constantemente
3. **Detecta automáticamente** cuando hay internet disponible
4. **Genera el archivo ZIP** con los datos y fotografías
5. **Envía por email** automáticamente usando el servicio configurado
6. **Confirma el envío** exitoso
7. **Limpia la cola** de encuestas pendientes

## Componentes Principales

### 1. AutoSyncService
- **Archivo**: `lib/services/auto_sync_service.dart`
- **Funcionalidad**: Gestiona el proceso completo de sincronización
- **Características**:
  - Monitoreo de conectividad en tiempo real
  - Almacenamiento persistente de encuestas pendientes
  - Reintentos automáticos en caso de fallo
  - Integración con EmailService y XmlExportService

### 2. EmailService
- **Archivo**: `lib/services/email_service.dart`
- **Funcionalidad**: Envío de correos electrónicos con archivos adjuntos
- **Características**:
  - Configuración centralizada de SMTP
  - Envío de archivos ZIP como adjuntos
  - Generación automática de contenido HTML y texto plano

### 3. XmlExportService
- **Archivo**: `lib/services/xml_export_service.dart`
- **Funcionalidad**: Generación de archivos XML y empaquetado en ZIP
- **Características**:
  - Exportación completa de datos a XML
  - Empaquetado de fotografías
  - Creación de archivos ZIP optimizados

### 4. SurveyState
- **Archivo**: `lib/models/survey_state.dart`
- **Funcionalidad**: Modelo de datos de la encuesta
- **Características**:
  - Método `toJson()` para serialización
  - Método `fromJson()` para deserialización
  - Compatibilidad con el sistema de sincronización

## Flujo de Funcionamiento

### 1. Envío de Encuesta
```dart
// El usuario completa la encuesta en observationsFormPage.dart
await AutoSyncService.scheduleImmediateSync(surveyData);
```

### 2. Almacenamiento Persistente
- Las encuestas se almacenan en SharedPreferences
- Cada encuesta tiene un ID único y timestamp
- Se mantiene un contador de intentos y estado

### 3. Monitoreo de Conectividad
```dart
// Monitoreo automático usando connectivity_plus
_connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
  if (result != ConnectivityResult.none) {
    _processPendingSurveys();
  }
});
```

### 4. Procesamiento Automático
```dart
// Conversión de datos JSON a SurveyState
final surveyState = SurveyState.fromJson(surveyData);

// Generación de archivo ZIP
final zipFile = await XmlExportService.createSurveyPackage(surveyState);

// Envío por email
final success = await EmailService.sendSurveyQuick(zipFile, surveyState);
```

## Configuración Requerida

### 1. Configuración de Email
Editar el archivo `lib/config/email_config.dart`:

```dart
class EmailConfig {
  static const String smtpHost = 'smtp.gmail.com';
  static const int smtpPort = 587;
  static const String senderEmail = 'tu_email@gmail.com';
  static const String senderPassword = 'tu_contraseña_app';
  static const String senderName = 'CaracT Móvil';
  static const String destinationEmail = 'destino@gmail.com';
  
  static bool get isConfigured => /* validación */;
}
```

### 2. Dependencias
Asegurarse de que estas dependencias estén en `pubspec.yaml`:

```yaml
dependencies:
  connectivity_plus: ^6.0.5
  shared_preferences: ^2.2.3
  mailer: ^6.1.2
  xml: ^6.5.0
  archive: ^3.6.1
  path_provider: ^2.1.4
```

## Características del Sistema

### ✅ Funcionamiento Automático
- **Sin intervención del usuario**: Una vez enviada la encuesta, todo es automático
- **Funcionamiento en segundo plano**: No requiere que la app esté abierta
- **Monitoreo continuo**: Revisa conectividad cada 5 minutos

### ✅ Robustez
- **Reintentos automáticos**: Hasta 3 intentos por encuesta
- **Manejo de errores**: Registro detallado de fallos
- **Recuperación automática**: Continúa procesando después de errores

### ✅ Almacenamiento Persistente
- **Datos seguros**: Encuestas guardadas en SharedPreferences
- **Recuperación**: Datos persisten entre reinicios de la app
- **Limpieza automática**: Encuestas enviadas se eliminan automáticamente

### ✅ Retroalimentación al Usuario
- **Estado en tiempo real**: Widget AutoSyncStatusWidget
- **Confirmaciones**: Mensajes de éxito/error
- **Transparencia**: El usuario sabe exactamente qué está pasando

## Interfaz de Usuario

### 1. Modal de Confirmación
En `observationsFormPage.dart`, el modal final muestra:
- Opción única de "Envío Automático"
- Descripción clara del proceso
- Botón principal verde prominente

### 2. Widget de Estado
`AutoSyncStatusWidget` muestra:
- Estado actual de conectividad
- Número de encuestas pendientes
- Última sincronización exitosa
- Indicador de proceso en curso

### 3. Página de Pruebas
`AutoSyncTestPage` permite:
- Simular envío de encuestas de prueba
- Forzar sincronización manual
- Verificar estado del sistema
- Limpiar encuestas pendientes

## Casos de Uso

### 1. Conectividad Disponible
1. Usuario completa encuesta
2. Sistema detecta conexión
3. Genera archivo ZIP inmediatamente
4. Envía por email automáticamente
5. Confirma envío exitoso

### 2. Sin Conectividad
1. Usuario completa encuesta
2. Sistema detecta falta de conexión
3. Guarda encuesta como pendiente
4. Monitorea conectividad automáticamente
5. Envía cuando detecta conexión

### 3. Fallo en Envío
1. Intento de envío falla
2. Sistema incrementa contador de intentos
3. Reintenta automáticamente
4. Después de 3 fallos, marca como error
5. Continúa intentando en verificaciones periódicas

## Ventajas del Sistema

- **✅ Automático**: Cero intervención del usuario
- **✅ Confiable**: Múltiples mecanismos de recuperación
- **✅ Eficiente**: Usa recursos mínimos del dispositivo
- **✅ Transparente**: Usuario siempre informado
- **✅ Robusto**: Maneja errores de red y configuración
- **✅ Integrado**: Utiliza servicios existentes de la app

## Mantenimiento y Monitoreo

### Logs del Sistema
El sistema genera logs detallados:
```
📤 Enviando encuesta: 1641234567890
✅ Encuesta enviada exitosamente por email
📊 Procesamiento completado: 1 éxitos, 0 fallos
```

### Estados Posibles
- `pending`: Encuesta esperando envío
- `processing`: Encuesta siendo procesada
- `synced`: Encuesta enviada exitosamente
- `error`: Error después de múltiples intentos

### Métricas Disponibles
- Número de encuestas pendientes
- Última sincronización exitosa
- Tasa de éxito/fallo
- Estado de conectividad

## Código de Ejemplo

### Programar Encuesta
```dart
final surveyData = surveyState.toJson();
await AutoSyncService.scheduleImmediateSync(surveyData);
```

### Verificar Estado
```dart
final status = await AutoSyncService.getSyncStatus();
print('Encuestas pendientes: ${status['pendingCount']}');
```

### Forzar Sincronización
```dart
await AutoSyncService.forceSyncNow();
```

## Solución de Problemas

### Email no configurado
- Verificar `email_config.dart`
- Usar credenciales de aplicación (no contraseña personal)
- Activar "Aplicaciones menos seguras" si es necesario

### Encuestas no se envían
- Verificar conectividad
- Revisar logs en consola
- Usar página de pruebas para diagnóstico

### Fallos persistentes
- Verificar configuración SMTP
- Revisar tamaño de archivos adjuntos
- Verificar credenciales de email

---

**Nota**: Este sistema está diseñado para funcionar de manera completamente automática y transparente para el usuario, asegurando que ninguna encuesta se pierda y que todas sean enviadas por email tan pronto como sea posible.
