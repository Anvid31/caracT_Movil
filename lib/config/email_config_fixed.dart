import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración centralizada para el envío de correos electrónicos
/// Los valores se obtienen del archivo .env (configuración fija)
class EmailConfig {
  // SMTP Configuration
  static String get smtpHost => dotenv.env['SMTP_HOST'] ?? 'smtp.gmail.com';
  static int get smtpPort => int.tryParse(dotenv.env['SMTP_PORT'] ?? '587') ?? 587;
  
  // Email Addresses (FIJOS desde .env)
  static String get destinationEmail => dotenv.env['DESTINATION_EMAIL'] ?? '';
  static String get senderEmail => dotenv.env['SENDER_EMAIL'] ?? '';
  
  // Credentials
  static String get senderPassword => dotenv.env['SENDER_PASSWORD'] ?? '';
  static String get senderName => dotenv.env['SENDER_NAME'] ?? 'CaracT Móvil';
  
  /// Verifica si la configuración está completa
  static bool get isConfigured {
    return destinationEmail.isNotEmpty &&
           senderEmail.isNotEmpty &&
           senderPassword.isNotEmpty;
  }
  
  /// Mensaje de ayuda para configuración
  static String get configurationHelp {
    if (!isConfigured) {
      return 'ERROR: Configure las variables de entorno en el archivo .env:\n'
             'DESTINATION_EMAIL, SENDER_EMAIL, SENDER_PASSWORD\n\n'
             'El archivo .env debe estar en la raíz del proyecto.';
    }
    return 'Configuración de correo cargada desde .env';
  }
}
