# CaracT Móvil - Caracterización CENS

Aplicación Flutter para caracterización de sedes educativas CENS (Centros Educativos de Nivel Superior).

## 📱 Características

- Formularios digitales para caracterización de infraestructura educativa
- Captura de fotografías y geolocalización
- Exportación de datos en formato XML
- Envío automático por correo electrónico
- Almacenamiento local con sincronización
- Interfaz moderna y responsiva

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

## 🔒 Seguridad

- **NUNCA** suba el archivo `.env` a control de versiones
- Use contraseñas de aplicación, no contraseñas normales
- El archivo `.env` está en `.gitignore` por seguridad
- Use `.env.example` como referencia para nuevas instalaciones

## 📁 Estructura del Proyecto

lib/
├── config/           # Configuraciones (temas, email)
├── models/           # Modelos de datos
├── services/         # Servicios (storage, email, export)
├── utils/            # Utilidades y helpers
├── views/            # Páginas de la aplicación
├── widgets/          # Widgets reutilizables
└── main.dart         # Punto de entrada

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework UI multiplataforma
- **Provider** - Gestión de estado
- **Hive** - Base de datos local
- **SQLite** - Almacenamiento relacional
- **Geolocator** - Servicios de ubicación
- **Image Picker** - Captura de fotografías
- **Mailer** - Envío de correos electrónicos
- **XML** - Exportación de datos
- **flutter_dotenv** - Variables de entorno seguras

## 📝 Uso

1. **Inicio**: Complete los datos básicos de la institución
2. **Formularios**: Navegue por los diferentes módulos de caracterización
3. **Fotografías**: Capture evidencias fotográficas geolocalizadas
4. **Revisión**: Verifique la información antes de enviar
5. **Envío**: Exporte y envíe automáticamente por correo

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
