import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/survey_state.dart';
import '../config/email_config.dart';

class EmailService {
  /// Envía el archivo ZIP al correo predefinido usando configuración centralizada
  static Future<bool> sendSurveyByEmail({
    required File zipFile,
    String? institutionName,
    String? municipio,
  }) async {
    // Verificar que la configuración esté lista
    if (!EmailConfig.isConfigured) {
      print('Error: Configuración de correo incompleta. ${EmailConfig.configurationHelp}');
      return false;
    }
    
    try {
      final smtpServer = SmtpServer(
        EmailConfig.smtpHost,
        port: EmailConfig.smtpPort,
        username: EmailConfig.senderEmail,
        password: EmailConfig.senderPassword,
        ignoreBadCertificate: false,
        ssl: false,
        allowInsecure: false,
      );

      final message = Message()
        ..from = const Address(EmailConfig.senderEmail, EmailConfig.senderName)
        ..recipients.add(EmailConfig.destinationEmail)
        ..subject = 'Caracterización de Sede Educativa - ${institutionName ?? 'Sede'} - ${municipio ?? ''}'
        ..text = _generateEmailBody(institutionName, municipio)
        ..html = _generateEmailHtml(institutionName, municipio)
        ..attachments.add(FileAttachment(zipFile));

      await send(message, smtpServer);
      print('Correo enviado exitosamente a ${EmailConfig.destinationEmail}');
      return true;
    } catch (e) {
      print('Error enviando correo: $e');
      return false;
    }
  }
    /// Método simplificado para envío rápido (solo requiere el archivo ZIP)
  static Future<bool> sendSurveyQuick(File zipFile, SurveyState surveyState) async {
    return await sendSurveyByEmail(
      zipFile: zipFile,
      institutionName: surveyState.institutionalInfo.institutionName,
      municipio: surveyState.generalInfo.municipality,
    );
  }
  
  /// Verifica si la configuración de correo está lista para usar
  static bool isEmailConfigured() {
    return EmailConfig.isConfigured;
  }
  
  /// Obtiene el mensaje de ayuda para configurar el correo
  static String getConfigurationHelp() {
    return EmailConfig.configurationHelp;
  }
  
  /// Comparte el archivo usando el sistema nativo de compartir
  static Future<void> shareZipFile(File zipFile, {String? institutionName}) async {
    try {
      final xFile = XFile(zipFile.path);
      await Share.shareXFiles(
        [xFile],
        text: 'Caracterización de sede educativa: ${institutionName ?? 'Sede'}\n\nGenerado con la aplicación CaracT Móvil',
        subject: 'Caracterización de Sede Educativa - ${institutionName ?? 'Sede'}',
      );
    } catch (e) {
      print('Error compartiendo archivo: $e');
    }
  }
  
  /// Copia el archivo ZIP a una ubicación accesible (Descargas)
  static Future<File?> copyToDownloads(File zipFile, {String? institutionName}) async {
    try {
      // Para Android, intentamos usar el directorio de Descargas
      Directory? targetDir;
      
      if (Platform.isAndroid) {
        // En Android, usamos getExternalStorageDirectory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          targetDir = Directory('${externalDir.path}/Download');
          if (!await targetDir.exists()) {
            await targetDir.create(recursive: true);
          }
        }
      } else if (Platform.isIOS) {
        // En iOS, usamos el directorio de documentos de la aplicación
        targetDir = await getApplicationDocumentsDirectory();
      }
      
      targetDir ??= await getApplicationDocumentsDirectory();
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final institutionNameClean = institutionName?.replaceAll(' ', '_').replaceAll(RegExp(r'[^\w\-_]'), '') ?? 'sede';
      final fileName = 'caracterizacion_${institutionNameClean}_$timestamp.zip';
      final targetFile = File('${targetDir.path}/$fileName');
      
      await zipFile.copy(targetFile.path);
      print('Archivo copiado a: ${targetFile.path}');
      return targetFile;
    } catch (e) {
      print('Error copiando archivo: $e');
      return null;
    }
  }
  
  /// Genera el cuerpo del correo en texto plano
  static String _generateEmailBody(String? institutionName, String? municipio) {
    return '''
Estimado/a usuario/a,

Adjunto encontrará la caracterización completa de la sede educativa realizada mediante la aplicación CaracT Móvil.

Detalles de la caracterización:
- Institución: ${institutionName ?? 'No especificado'}
- Municipio: ${municipio ?? 'No especificado'}
- Fecha de generación: ${DateTime.now().toLocal().toString().split('.')[0]}

El archivo ZIP contiene:
- Archivo XML con toda la información recopilada
- Fotografías de la sede educativa organizadas por categorías

Esta información ha sido recopilada siguiendo los protocolos establecidos para la caracterización de sedes educativas rurales.

Para cualquier consulta o aclaración, no dude en contactarnos.

Atentamente,
Equipo CaracT Móvil
''';
  }
  
  /// Genera el cuerpo del correo en HTML
  static String _generateEmailHtml(String? institutionName, String? municipio) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px; margin-bottom: 20px; }
        .content { line-height: 1.6; color: #333; }
        .details { background-color: #f9f9f9; padding: 15px; border-left: 4px solid #4CAF50; margin: 20px 0; }
        .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #666; font-size: 14px; }
        .highlight { color: #4CAF50; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 CaracT Móvil</h1>
            <p>Caracterización de Sede Educativa</p>
        </div>
        
        <div class="content">
            <p>Estimado/a usuario/a,</p>
            
            <p>Adjunto encontrará la caracterización completa de la sede educativa realizada mediante la aplicación <span class="highlight">CaracT Móvil</span>.</p>
            
            <div class="details">
                <h3>📋 Detalles de la caracterización:</h3>
                <ul>
                    <li><strong>Institución:</strong> ${institutionName ?? 'No especificado'}</li>
                    <li><strong>Municipio:</strong> ${municipio ?? 'No especificado'}</li>
                    <li><strong>Fecha de generación:</strong> ${DateTime.now().toLocal().toString().split('.')[0]}</li>
                </ul>
            </div>
            
            <h3>📁 Contenido del archivo ZIP:</h3>
            <ul>
                <li>📄 <strong>Archivo XML</strong> con toda la información recopilada</li>
                <li>📸 <strong>Fotografías</strong> de la sede educativa organizadas por categorías</li>
            </ul>
            
            <p>Esta información ha sido recopilada siguiendo los protocolos establecidos para la caracterización de sedes educativas rurales.</p>
            
            <p>Para cualquier consulta o aclaración, no dude en contactarnos.</p>
        </div>
        
        <div class="footer">
            <p><strong>Atentamente,</strong><br>
            Equipo CaracT Móvil</p>
            <p><em>Sistema de Caracterización de Sedes Educativas</em></p>
        </div>
    </div>
</body>
</html>
''';
  }
  
  /// Valida una dirección de correo electrónico
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Configuración rápida para diferentes proveedores de correo
  static Map<String, Map<String, dynamic>> getEmailProviders() {
    return {
      'Gmail': {
        'smtp': 'smtp.gmail.com',
        'port': 587,
        'help': 'Usa tu email de Gmail y una contraseña de aplicación'
      },
      'Outlook/Hotmail': {
        'smtp': 'smtp-mail.outlook.com',
        'port': 587,
        'help': 'Usa tu email de Outlook/Hotmail y contraseña normal'
      },
      'Yahoo': {
        'smtp': 'smtp.mail.yahoo.com',
        'port': 587,
        'help': 'Usa tu email de Yahoo y una contraseña de aplicación'
      },
    };
  }
}
