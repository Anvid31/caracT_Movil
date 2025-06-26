/// Configuración central para el servicio de correo electrónico
/// 
/// IMPORTANTE: Antes de usar en producción, configure estos valores
/// con las credenciales reales de su cuenta de correo.
class EmailConfig {
  /// Dirección de correo destino donde se enviarán todas las caracterizaciones
  static const String destinationEmail = 'mendozadiazjuandavid@gmail.com';
  
  /// Dirección de correo emisor (cuenta que enviará los correos)
  /// DEBE configurar esto con una cuenta real antes de usar en producción
  static const String senderEmail = 'anvid3107@gmail.com';
  
  /// Contraseña de aplicación para la cuenta emisora
  /// IMPORTANTE: Para Gmail, debe generar una "Contraseña de aplicación"
  /// 1. Vaya a https://myaccount.google.com/security
  /// 2. Active la verificación en 2 pasos
  /// 3. Genere una contraseña de aplicación para "Correo"
  /// 4. Use esa contraseña aquí (NO su contraseña normal)
  static const String senderPassword = 'wkgn vrga vryj xazs';
  
  /// Configuración del servidor SMTP
  static const String smtpHost = 'smtp.gmail.com';
  static const int smtpPort = 587;
  
  /// Nombre que aparecerá como remitente
  static const String senderName = 'CaracT Móvil';
    /// Validar si la configuración está lista para producción
  static bool get isConfigured {
    return senderPassword.isNotEmpty &&
           senderPassword != 'tu_contraseña_de_aplicacion_aqui' &&
           senderEmail.contains('@') &&
           destinationEmail.contains('@') &&
           senderEmail.isNotEmpty &&
           destinationEmail.isNotEmpty;
  }
  
  /// Obtener mensaje de ayuda para configuración
  static String get configurationHelp => '''
Para configurar el envío automático de correos:

1. CONFIGURAR CUENTA EMISORA:
   - Edite lib/config/email_config.dart
   - Cambie senderEmail por su cuenta real de Gmail
   - Cambie senderPassword por su contraseña de aplicación

2. GENERAR CONTRASEÑA DE APLICACIÓN (Gmail):
   a) Vaya a https://myaccount.google.com/security
   b) Active la verificación en 2 pasos si no está activa
   c) En "Contraseñas de aplicaciones", genere una nueva
   d) Seleccione "Correo" como aplicación
   e) Copie la contraseña generada (16 caracteres)
   f) Use esa contraseña en senderPassword

3. OPCIONAL - CAMBIAR DESTINO:
   - Cambie destinationEmail por la cuenta que debe recibir los reportes

4. VERIFICAR CONFIGURACIÓN:
   - Pruebe el envío desde la página final del formulario
   - Verifique que lleguen los correos antes de usar en producción
''';
}
