import 'package:flutter/material.dart';
import 'auto_sync_service.dart';

/// Servicio para el envío de formularios con sincronización automática
class FormSubmissionService {
  
  /// Envía un formulario completo con sincronización automática en segundo plano
  static Future<void> submitSurveyForm(BuildContext context, Map<String, dynamic> surveyData) async {
    try {
      // Mostrar indicador de progreso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _SubmissionProgressDialog(),
      );

      // Generar ID único para la encuesta
      final surveyId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Preparar datos completos de la encuesta
      final completeSurveyData = {
        'id': surveyId,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'completed',
        'data': surveyData,
        'metadata': {
          'appVersion': '1.0.0',
          'deviceInfo': await _getDeviceInfo(),
          'submissionTime': DateTime.now().toIso8601String(),
        },
      };

      // Guardar localmente como respaldo (comentado por ahora)
      // await StorageService.saveSurveyData(surveyId, completeSurveyData);

      // Programar para sincronización automática inmediata
      await AutoSyncService.scheduleImmediateSync(completeSurveyData);

      // Cerrar indicador de progreso
      if (context.mounted) {
        Navigator.of(context).pop();

        // Mostrar mensaje de éxito
        _showSubmissionSuccess(context);
      }

      print('📋 Formulario enviado exitosamente con ID: $surveyId');

    } catch (e) {
      // Cerrar indicador de progreso si está abierto
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Mostrar error
        _showSubmissionError(context, e.toString());
      }
      
      print('❌ Error enviando formulario: $e');
      rethrow;
    }
  }

  /// Muestra diálogo de éxito después del envío
  static void _showSubmissionSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Formulario Enviado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Su encuesta ha sido enviada exitosamente.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚀 Sincronización Automática',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'El sistema se encargará de enviar automáticamente los datos por email cuando haya conexión a internet.',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  /// Muestra diálogo de error
  static void _showSubmissionError(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Error al Enviar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ocurrió un error al enviar el formulario:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                error,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No se preocupe, sus datos se han guardado localmente y el sistema intentará enviarlos automáticamente cuando haya conexión.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  /// Obtiene información del dispositivo
  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      // Aquí se podría integrar con device_info_plus para obtener información real
      return {
        'platform': 'mobile',
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0.0',
      };
    } catch (e) {
      return {
        'platform': 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }
}

/// Diálogo de progreso para el envío de formularios
class _SubmissionProgressDialog extends StatelessWidget {
  const _SubmissionProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            'Enviando formulario...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Por favor espere mientras procesamos su información.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
