import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/observationsInfo.dart';
import '../models/survey_state.dart';
import '../services/auto_sync_service.dart';
import '../widgets/form/custom_text_field.dart';
import '../widgets/layout/enhanced_form_container.dart';
import '../utils/form_navigator.dart';

class ObservationsFormPage extends StatefulWidget {
  const ObservationsFormPage({super.key});

  @override
  State<ObservationsFormPage> createState() => _ObservationsFormPageState();
}

class _ObservationsFormPageState extends State<ObservationsFormPage> {
  final _formKey = GlobalKey<FormState>();
  late ObservationsInfo _observationsInfo;

  @override
  void initState() {
    super.initState();
    final surveyState = Provider.of<SurveyState>(context, listen: false);
    _observationsInfo = surveyState.observationsInfo;
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFormContainer(
      title: 'Observaciones Finales',
      subtitle: 'Último paso - Complete la caracterización',
      currentStep: 9,
      onPrevious: () => FormNavigator.popForm(context),
      onNext: _submitForm,
      nextLabel: 'Finalizar y Enviar',
      showPrevious: true,
      transitionType: FormTransitionType.slideScale,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Caja informativa con descripción
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF607D8B).withValues(alpha: 0.1),
                        const Color(0xFF607D8B).withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF607D8B).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.comment_outlined,
                        size: 32,
                        color: Color(0xFF607D8B),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Observaciones Finales',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comparta comentarios adicionales o información relevante sobre la sede educativa',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                CustomTextField(
                  label: 'Observaciones adicionales',
                  hintText: 'Agregue cualquier información adicional relevante',
                  initialValue: _observationsInfo.additionalObservations,
                  onChanged: (value) => _observationsInfo.additionalObservations = value,
                  maxLines: 5,
                ),
                
                const SizedBox(height: 24),
                
                // Mensaje informativo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Al enviar completará la caracterización de la sede educativa. Podrá compartir, enviar por email o guardar los resultados.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 80), // Espacio para los botones fijos
              ],
            ),
          ),
        ),
      ),
    );
  }  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Obtener el estado completo de la encuesta
      final surveyState = Provider.of<SurveyState>(context, listen: false);
      
      // Actualizar las observaciones
      surveyState.updateObservationsInfo(_observationsInfo);
      
      // DEBUG: Verificar el estado fotográfico antes del envío
      final photoInfo = surveyState.photographicRecordInfo;
      print('🔍 ANTES DEL ENVÍO - Estado del registro fotográfico:');
      print('   - generalPhoto: ${photoInfo.generalPhoto}');
      print('   - infrastructurePhoto: ${photoInfo.infrastructurePhoto}');
      print('   - electricityPhoto: ${photoInfo.electricityPhoto}');
      print('   - environmentPhoto: ${photoInfo.environmentPhoto}');
      print('   - frontSchoolPhoto: ${photoInfo.frontSchoolPhoto}');
      print('   - classroomsPhoto: ${photoInfo.classroomsPhoto}');
      print('   - kitchenPhoto: ${photoInfo.kitchenPhoto}');
      print('   - diningRoomPhoto: ${photoInfo.diningRoomPhoto}');
      print('   - additionalPhotos: ${photoInfo.additionalPhotos}');
      
      // Mostrar diálogo simple de confirmación y activar sincronización
      _showFinalSubmissionDialog(surveyState);
    }
  }
  
  void _showFinalSubmissionDialog(SurveyState surveyState) {
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
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Enviar Formulario'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Cómo desea enviar la información recopilada?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Icon(Icons.cloud_upload, color: Colors.blue, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Envío Automático',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Se detectará automáticamente la conexión y se enviará por correo electrónico',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _scheduleAutomaticSync(surveyState);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Envío Automático'),
          ),
        ],
      ),
    );
  }

  /// Programa el envío automático en segundo plano
  void _scheduleAutomaticSync(SurveyState surveyState) async {
    _showLoadingDialog('Programando envío automático...');
    
    try {
      // Convertir surveyState a Map para almacenamiento
      final surveyData = surveyState.toJson();
      
      // Programar para sincronización automática con el nuevo servicio
      await AutoSyncService.scheduleImmediateSync(surveyData);
      
      Navigator.of(context).pop(); // Cerrar loading
      
      // Mostrar confirmación con información sobre el envío automático
      _showAutomaticSyncConfirmation();
      
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar loading
      _showErrorDialog('Error programando envío automático: $e');
    }
  }
  
  /// Muestra confirmación del envío automático programado
  void _showAutomaticSyncConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_done,
                color: Colors.green.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Envío Programado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ Su formulario ha sido guardado exitosamente',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wifi_find, color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Monitoreo Automático Activado',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• La app buscará conexión automáticamente\n'
                    '• Se enviará cuando detecte WiFi o datos móviles\n'
                    '• Funciona incluso si cierra la aplicación\n'
                    '• Recibirá confirmación por correo electrónico',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade600, size: 18),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Puede cerrar la app de forma segura',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).popUntil((route) => route.isFirst); // Volver al inicio
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
  
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
