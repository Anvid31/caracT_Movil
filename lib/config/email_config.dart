import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración central para el servicio de correo electrónico
/// 
/// IMPORTANTE: Las credenciales se cargan desde el archivo .env
/// que NUNCA debe subirse a control de versiones.
class EmailConfig {
  /// Dirección de correo destino donde se enviarán todas las caracterizaciones
  static String get destinationEmail => 
      dotenv.env['DESTINATION_EMAIL'] ?? 'mendozadiazjuandavid@gmail.com';
  
  /// Dirección de correo emisor (cuenta que enviará los correos)
  static String get senderEmail => 
      dotenv.env['SENDER_EMAIL'] ?? '';
  
  /// Contraseña de aplicación para la cuenta emisora
  /// Esta debe ser una contraseña de aplicación de Gmail, NO la contraseña normal
  static String get senderPassword => 
      dotenv.env['SENDER_PASSWORD'] ?? '';
  
  /// Configuración del servidor SMTP
  static String get smtpHost => 
      dotenv.env['SMTP_HOST'] ?? 'smtp.gmail.com';
  
  static int get smtpPort => 
      int.tryParse(dotenv.env['SMTP_PORT'] ?? '587') ?? 587;
  
  /// Nombre que aparecerá como remitente
  static String get senderName => 
      dotenv.env['SENDER_NAME'] ?? 'CaracT Móvil';
    /// Validar si la configuración está lista para producción
  static bool get isConfigured {
    return senderPassword.isNotEmpty &&
           senderEmail.contains('@') &&
           destinationEmail.contains('@') &&
           senderEmail.isNotEmpty &&
           destinationEmail.isNotEmpty;
  }
  
  /// Obtener mensaje de ayuda para configuración
  static String get configurationHelp => '''
Para configurar el envío automático de correos:

1. CREAR ARCHIVO .env:
   - Copie el archivo .env.example como .env
   - El archivo .env NUNCA se debe subir a GitHub (ya está en .gitignore)

2. CONFIGURAR VARIABLES EN .env:
   - SENDER_EMAIL: Su cuenta de Gmail
   - SENDER_PASSWORD: Contraseña de aplicación (ver paso 3)
   - DESTINATION_EMAIL: Correo que recibirá los reportes

3. GENERAR CONTRASEÑA DE APLICACIÓN (Gmail):
   a) Vaya a https://myaccount.google.com/security
   b) Active la verificación en 2 pasos si no está activa
   c) En "Contraseñas de aplicaciones", genere una nueva
   d) Seleccione "Correo" como aplicación
   e) Copie la contraseña generada (16 caracteres)
   f) Úsela en SENDER_PASSWORD del archivo .env

4. VERIFICAR CONFIGURACIÓN:
   - Pruebe el envío desde la página final del formulario
   - Verifique que lleguen los correos antes de usar en producción
   
IMPORTANTE: El archivo .env es privado y local, nunca lo suba a GitHub.
''';
}
