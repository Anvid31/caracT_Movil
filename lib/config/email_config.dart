import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración de email fija basada en variables de entorno
class EmailConfig {
  /// Email de destino para recibir los formularios
  static String get destinationEmail => dotenv.env['DESTINATION_EMAIL'] ?? '';
  
  /// Email del remitente (cuenta de envío)
  static String get senderEmail => dotenv.env['SENDER_EMAIL'] ?? '';
  
  /// Contraseña del remitente
  static String get senderPassword => dotenv.env['SENDER_PASSWORD'] ?? '';
  
  /// Nombre para mostrar del remitente
  static String get senderName => dotenv.env['SENDER_NAME'] ?? displayName;
  
  /// Verifica si la configuración de email está completa
  static bool get isConfigured {
    return destinationEmail.isNotEmpty && 
           senderEmail.isNotEmpty && 
           senderPassword.isNotEmpty;
  }
  
  /// Nombre para mostrar del remitente
  static String get displayName => 'Caracterización CENS';
  
  /// Servidor SMTP (Gmail por defecto)
  static String get smtpServer => 'smtp.gmail.com';
  
  /// Puerto SMTP
  static int get smtpPort => 587;
}
