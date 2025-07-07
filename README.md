# CaracT Móvil - Caracterización CENS

Aplicación Flutter para caracterización de sedes educativas CENS (Centros Educativos de Nivel Superior).

## 📱 Características

### ✅ Formularios Inteligentes

- Formularios digitales para caracterización de infraestructura educativa
- Captura de fotografías geolocalizadas
- Validación en tiempo real
- Guardado automático de progreso

### 🔄 **NUEVO: Sistema de Sincronización Automática**

- **Envío automático en segundo plano** - Funciona incluso con la app cerrada
- **Monitoreo continuo de conectividad** - Busca WiFi y datos móviles automáticamente
- **Persistencia de datos** - Nunca se pierden formularios por falta de conexión
- **Sincronización inteligente** - Envía automáticamente cuando detecta internet
- **Widget de estado en tiempo real** - Muestra conectividad y formularios pendientes

### 📤 Exportación y Envío

- Exportación de datos en formato XML + ZIP
- Envío automático por correo electrónico
- Compartir archivos nativamente
- Almacenamiento local con Hive

### 🎨 Interfaz de Usuario

- Diseño moderno y responsivo
- Transiciones fluidas entre pantallas
- Feedback visual constante
- Modo oscuro/claro automático

## 🚀 Instalación y Configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/KENSHIN11083012/caracT_Movil.git
cd caracT_Movil
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar variables de entorno (IMPORTANTE)

**Para seguridad, las credenciales de correo se manejan con variables de entorno:**

1. Copie el archivo de ejemplo:

   ```bash
   cp .env.example .env
   ```

2. Edite el archivo `.env` con sus credenciales reales:

   ```env
   DESTINATION_EMAIL=tu_correo_destino@gmail.com
   SENDER_EMAIL=tu_cuenta_gmail@gmail.com
   SENDER_PASSWORD=tu_contraseña_de_aplicacion_16_caracteres
   ```

3. **Para Gmail, genere una contraseña de aplicación:**
   - Vaya a [Google Account Security](https://myaccount.google.com/security)
   - Active la verificación en 2 pasos
   - Genere una contraseña de aplicación para "Correo"
   - Use esa contraseña en `SENDER_PASSWORD` (NO su contraseña normal)

### 4. Ejecutar la aplicación

```bash
flutter run
```

## 🔄 Sistema de Sincronización Automática

### 🎯 Descripción

El sistema de sincronización automática garantiza que **ningún formulario se pierda** por falta de conexión a internet. Funciona de manera inteligente en segundo plano, monitoreando constantemente la conectividad y enviando automáticamente cuando detecta una red disponible.

### ⚡ Características Principales

#### ✅ Envío Automático Inteligente

- **Detección automática**: Monitorea WiFi y datos móviles continuamente
- **Trabajo en segundo plano**: Funciona incluso con la aplicación cerrada
- **Persistencia**: Guarda formularios pendientes de forma segura
- **Reintento automático**: Intenta enviar cuando recupera conexión

#### ✅ Interfaz de Usuario Optimizada

- **Widget de estado en tiempo real**: Muestra conectividad y formularios pendientes
- **Opción "Envío Automático"**: Primera opción recomendada en el diálogo
- **Confirmación inteligente**: Explica el funcionamiento automático
- **Feedback visual**: Colores intuitivos (🟢 conectado, 🟠 esperando)

### 🚀 Cómo Funciona

#### Flujo de Usuario

```
1. Usuario completa formulario
   ↓
2. Presiona "Enviar Formulario"
   ↓
3. Selecciona "Envío Automático" (recomendado)
   ↓
4. Sistema verifica conectividad:
   ✅ Con internet → Envía inmediatamente
   ❌ Sin internet → Guarda y programa envío automático
   ↓
5. Monitoreo continuo en segundo plano
   ↓
6. Al detectar red → Envía automáticamente
   ↓
7. Confirmación por correo electrónico
```

#### Tecnología Subyacente

- **Sistema de Sincronización Personalizado**: Tareas en segundo plano usando Dart Timers
- **Connectivity Plus**: Monitoreo de red en tiempo real
- **Almacenamiento en Memoria**: Cache temporal para formularios pendientes
- **Monitoreo Continuo**: Verificación automática de conectividad cada 30 segundos

### 🎮 Página de Pruebas

#### Acceso

- **FloatingActionButton azul** (⚡) en la página "Información General"
- Permite probar todas las funcionalidades del sistema

#### Funcionalidades de Prueba

1. **Simular Envío**: Crea formularios de prueba para sincronización
2. **Actualizar Estado**: Verifica el estado actual del sistema
3. **Limpiar Pendientes**: Elimina datos de prueba
4. **Monitoreo en Vivo**: Widget de estado en tiempo real

#### Cómo Probar

```
1. Ir a "Información General" → Presionar botón azul ⚡
2. Presionar "Simular Envío de Encuesta"
3. Desactivar WiFi y datos móviles
4. Observar cambio de estado a "Sin conexión"
5. Reactivar conexión a internet
6. Ver sincronización automática en acción
7. Cerrar app para confirmar funcionamiento en segundo plano
```

### 🎨 Interfaz Visual

#### Widget de Estado (Parte Superior)

- **🟢 Verde**: "Conectado - Sincronizando automáticamente"
- **🟠 Naranja**: "Sin conexión - Esperando conectividad"
- **Contador**: Muestra número de formularios pendientes
- **Botón "Sincronizar"**: Permite sincronización manual inmediata

#### Diálogo de Envío Mejorado

```
┌─────── Enviar Formulario ───────┐
│                                 │
│  ┌── ENVÍO AUTOMÁTICO ──┐       │
│  │   🔄 ¡Recomendado!   │ ← Principal
│  └─────────────────────┘       │
│                                 │
│  ┌─ Opciones Adicionales ─┐     │
│  │ Compartir│Email│Guardar │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

#### Confirmación Inteligente

- **Ícono verde con cloud**: Confirmación visual clara
- **Explicación detallada**: Qué hace el sistema automáticamente
- **Instrucciones de uso**: "Puede cerrar la app sin problemas"
- **Estado del monitoreo**: "Monitoreo automático activado"

### ⚙️ Configuración Técnica

#### Permisos Android (Agregados)

```xml
<!-- Trabajo en segundo plano -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
```

#### Dependencias Principales

```yaml
dependencies:
  connectivity_plus: ^5.0.2  # Monitoreo de conectividad
  provider: ^6.1.1          # Gestión de estado
```

### 🔍 Monitoreo y Logs

#### Estados de Sincronización

- **pending**: Formulario guardado, esperando envío
- **syncing**: En proceso de envío
- **synced**: Enviado exitosamente
- **error**: Error en envío (reintentará automáticamente)

#### Logs de Depuración

```
✅ Background sync service inicializado exitosamente
🔍 Conectividad detectada, procesando encuestas pendientes...
📤 Encuesta [ID] enviada exitosamente
⚙️ Ejecutando tarea en segundo plano: [task]
```

## 🔒 Seguridad

- **NUNCA** suba el archivo `.env` a control de versiones
- Use contraseñas de aplicación, no contraseñas normales
- El archivo `.env` está en `.gitignore` por seguridad
- Use `.env.example` como referencia para nuevas instalaciones

## 📁 Estructura del Proyecto

```
lib/
├── config/                    # Configuraciones
│   ├── email_config.dart     # Configuración centralizada de correo
│   └── theme.dart            # Temas y estilos
├── models/                    # Modelos de datos
│   ├── survey_state.dart     # Estado principal de la encuesta
│   ├── *_info.dart          # Modelos para cada sección
│   └── ...
├── services/                  # Servicios y lógica de negocio
│   ├── background_sync_service.dart  # 🆕 Sincronización automática
│   ├── storage_service.dart          # Almacenamiento local (Hive)
│   ├── email_service.dart            # Envío de correos
│   ├── xml_export_service.dart       # Exportación XML + ZIP
│   └── location_service.dart         # Servicios de ubicación
├── utils/                     # Utilidades y helpers
│   ├── form_navigator.dart    # Navegación entre formularios
│   ├── permission_helper.dart # 🆕 Gestión de permisos
│   └── location_data.dart     # Datos de ubicación
├── views/                     # Páginas de la aplicación
│   ├── survey_form_page.dart          # Página principal
│   ├── auto_sync_test_page.dart       # 🆕 Página de pruebas
│   ├── observationsFormPage.dart      # 🆕 Con envío automático
│   └── *FormPage.dart                 # Otras páginas de formularios
├── widgets/                   # Widgets reutilizables
│   ├── sync_status_widget.dart        # 🆕 Widget de estado de sync
│   ├── form/                          # Widgets de formularios
│   │   ├── photo_capture_field.dart   # Captura de fotos mejorada
│   │   └── ...
│   ├── layout/                        # Widgets de diseño
│   │   ├── enhanced_form_container.dart  # Container con FAB
│   │   └── ...
│   └── animations/                    # Animaciones
└── main.dart                  # 🆕 Con inicialización de background sync
```

## 🛠️ Tecnologías Utilizadas

### 📱 Framework Principal

- **Flutter** - Framework UI multiplataforma
- **Dart** - Lenguaje de programación

### 🔧 Gestión de Estado y Datos

- **Provider** - Gestión de estado reactiva
- **Hive** - Base de datos local NoSQL ultrarrápida
- **SQLite** - Almacenamiento relacional complementario

### 🔄 **NUEVAS: Sincronización y Background**

- **Sistema de Sincronización Personalizado** - Tareas en segundo plano usando timers de Dart
- **Connectivity Plus** - Monitoreo de conectividad en tiempo real

### 📍 Servicios de Ubicación

- **Geolocator** - GPS y servicios de ubicación
- **Permission Handler** - Gestión de permisos del sistema

### 📸 Multimedia

- **Image Picker** - Captura de fotografías desde cámara/galería
- **Camera** - Control avanzado de cámara

### 📤 Exportación y Comunicación

- **Mailer** - Envío de correos electrónicos SMTP
- **XML** - Generación de archivos XML estructurados
- **Archive** - Creación de archivos ZIP
- **Share Plus** - Compartir archivos nativamente

### 🔒 Seguridad

- **flutter_dotenv** - Variables de entorno seguras
- **Path Provider** - Rutas del sistema de forma segura

### 🎨 UI/UX

- **Material Design** - Diseño consistente multiplataforma
- **Custom Animations** - Transiciones fluidas personalizadas

## 📝 Uso de la Aplicación

### 🚀 Flujo Principal

1. **Inicio**: Complete los datos básicos de la institución en "Información General"
2. **Formularios**: Navegue por los 9 módulos de caracterización:
   - Información Institucional
   - Cobertura y Conectividad  
   - Infraestructura
   - Energía Eléctrica
   - Electrodomésticos
   - Ruta de Acceso
   - Registro Fotográfico
   - Observaciones Finales
3. **Fotografías**: Capture evidencias fotográficas geolocalizadas
4. **Revisión**: Verifique toda la información antes de enviar
5. **🆕 Envío Automático**: Use la nueva opción principal "Envío Automático"

### 🔄 **NUEVO: Envío Automático Garantizado**

#### ✅ Ventajas del Nuevo Sistema

- **Nunca pierde datos**: Formularios guardados aunque no haya internet
- **Envío inteligente**: Se envía automáticamente al detectar conexión
- **Funciona en background**: Incluso con la app cerrada
- **Confirmación automática**: Recibe email cuando se envía exitosamente
- **Estado visual**: Widget que muestra progreso en tiempo real

#### 🎯 Cómo Usar el Envío Automático

```
1. Complete todos los formularios normalmente
   ↓
2. En "Observaciones Finales" → Presione "Enviar Formulario"
   ↓
3. Seleccione "ENVÍO AUTOMÁTICO" (opción destacada)
   ↓
4. ✅ ¡Listo! El sistema se encarga de todo automáticamente
   ↓
5. Puede cerrar la app sin problemas
   ↓
6. Recibirá email de confirmación cuando se envíe
```

#### 📊 Widget de Estado (Monitoreo Visual)

El widget en la parte superior muestra:

- **🟢 Verde**: "Conectado - Sincronizando automáticamente"
- **🟠 Naranja**: "Sin conexión - Esperando conectividad"  
- **Contador**: Número de formularios pendientes de envío
- **Botón "Sincronizar"**: Para forzar sincronización manual

### 🧪 Página de Pruebas

- **Acceso**: Botón azul ⚡ en "Información General"
- **Función**: Probar todas las características del sistema automático
- **Ideal para**: Verificar funcionamiento antes del trabajo de campo

### 📤 Opciones de Envío Adicionales

Además del envío automático, también puede:

- **Compartir**: Envío mediante apps nativas del dispositivo
- **Email**: Configuración manual de correo (requiere configuración)
- **Guardar**: Almacenar archivo ZIP en el dispositivo

## 🤝 Contribución

1. Fork el proyecto
2. Cree una rama para su feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit sus cambios (`git commit -m 'Add: Nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abra un Pull Request

## 📄 Licencia

Este proyecto es privado y está destinado únicamente para uso interno de la institución educativa.

## 📞 Soporte

Para soporte técnico o reportar problemas, contacte al equipo de desarrollo.

## 🆕 Últimas Mejoras Implementadas

### 🔄 Sistema de Sincronización Automática (v1.2.0)

**Fecha**: Enero 2025

#### ✨ Nuevas Características

- **Envío automático en segundo plano**: Los formularios se envían automáticamente cuando se detecta conexión
- **Monitoreo continuo**: Búsqueda inteligente de WiFi y datos móviles cada 15 minutos
- **Persistencia garantizada**: Nunca se pierden datos por falta de conectividad
- **Widget de estado en tiempo real**: Feedback visual constante del estado de sincronización
- **Página de pruebas completa**: Herramientas para validar toda la funcionalidad

#### 🔧 Mejoras Técnicas

- **Sistema de Sincronización Personalizado**: Implementado para tareas en segundo plano usando Dart Timers
- **Connectivity Plus**: Monitoreo de red mejorado y más preciso
- **Background Tasks**: Funcionamiento continuo incluso con app cerrada
- **UI/UX optimizada**: Nuevo diálogo de envío con opción principal destacada

#### 📱 Archivos Nuevos/Modificados

```
🆕 lib/services/background_sync_service.dart
🆕 lib/widgets/sync_status_widget.dart
🆕 lib/views/auto_sync_test_page.dart
🆕 lib/utils/permission_helper.dart
📝 lib/views/observationsFormPage.dart (actualizada)
📝 lib/widgets/layout/enhanced_form_container.dart (con FAB)
📝 android/app/src/main/AndroidManifest.xml (permisos)
📝 pubspec.yaml (nueva dependencia)
```

#### 🎯 Beneficios para el Usuario

- **Tranquilidad total**: Puede cerrar la app sin preocuparse por envíos pendientes
- **Experiencia fluida**: No interrupciones por problemas de conectividad
- **Feedback claro**: Siempre sabe el estado de sus formularios
- **Confirmación automática**: Recibe email cuando se completa el envío
- **Modo offline completo**: Funciona perfectamente sin internet inicial

### 🔮 Próximas Características Planificadas

- **Notificaciones push**: Alertas cuando se complete la sincronización
- **Estadísticas de envío**: Dashboard con métricas de sincronización
- **Modo de ahorro de batería**: Optimización inteligente de recursos
- **Sincronización selectiva**: Configuración de tipos de red preferidos

---

> **Nota**: Esta aplicación ha sido optimizada para trabajo de campo en zonas con conectividad limitada. El sistema de sincronización automática garantiza que ningún dato se pierda, proporcionando una experiencia confiable y sin interrupciones para la caracterización de sedes educativas.
