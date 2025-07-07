import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/survey_state.dart';
import '../services/form_submission_service.dart';
import '../widgets/layout/enhanced_form_container.dart';
import '../widgets/auto_sync_status_widget.dart';
import '../utils/form_navigator.dart';

/// Página final para revisar y enviar el formulario completo
class FormSummaryPage extends StatefulWidget {
  const FormSummaryPage({super.key});

  @override
  State<FormSummaryPage> createState() => _FormSummaryPageState();
}

class _FormSummaryPageState extends State<FormSummaryPage> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyState>(
      builder: (context, surveyState, child) {
        return EnhancedFormContainer(
          title: 'Resumen de la Encuesta',
          subtitle: 'Revise y envíe su formulario',
          currentStep: 9,
          onPrevious: () => FormNavigator.popForm(context),
          onNext: _submitForm,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estado de sincronización
                const AutoSyncStatusWidget(),
                
                const SizedBox(height: 24),
                
                // Resumen de secciones
                _buildSectionSummary('Información General', [
                  'Fecha: ${surveyState.generalInfo.date?.toString().split(' ')[0] ?? 'No especificada'}',
                  'Departamento: ${surveyState.generalInfo.department ?? 'No especificado'}',
                  'Municipio: ${surveyState.generalInfo.municipality ?? 'No especificado'}',
                  'Entrevistado: ${surveyState.generalInfo.intervieweeName ?? 'No especificado'}',
                ]),
                
                const SizedBox(height: 16),
                
                _buildSectionSummary('Información Institucional', [
                  'Nombre: ${surveyState.institutionalInfo.institutionName ?? 'No especificado'}',
                  'Tipo: ${surveyState.institutionalInfo.institutionType ?? 'No especificado'}',
                  'Zona: ${surveyState.institutionalInfo.zone ?? 'No especificado'}',
                ]),
                
                const SizedBox(height: 16),
                
                _buildSectionSummary('Infraestructura', [
                  'Espacios disponibles: ${_getInfrastructureSpaces(surveyState)}',
                  'Propiedad: ${surveyState.infrastructureInfo.propiedadPredio}',
                  if (surveyState.infrastructureInfo.proyectosInfraestructura.isNotEmpty)
                    'Proyectos: ${surveyState.infrastructureInfo.proyectosInfraestructura}',
                ]),
                
                const SizedBox(height: 24),
                
                // Información sobre el envío
                _buildSubmissionInfo(),
                
                const SizedBox(height: 24),
                
                // Botón de envío
                if (_isSubmitting)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Enviando formulario...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Enviar Formulario Completo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionSummary(String title, List<String> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Envío Automático',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Al enviar este formulario:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            '• Se guardará automáticamente en el dispositivo\n'
            '• Se enviará por email en segundo plano\n'
            '• Funcionará aunque cierre la aplicación\n'
            '• Se reintentará automáticamente si hay problemas de conexión\n'
            '• Recibirá confirmación cuando se complete el envío',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  String _getInfrastructureSpaces(SurveyState surveyState) {
    final spaces = <String>[];
    final info = surveyState.infrastructureInfo;
    
    if (info.hasSalones) spaces.add('Salones (${info.cantidadSalones})');
    if (info.hasComedor) spaces.add('Comedor (${info.cantidadComedor})');
    if (info.hasCocina) spaces.add('Cocina (${info.cantidadCocina})');
    if (info.hasSalonReuniones) spaces.add('Salón reuniones (${info.cantidadSalonReuniones})');
    if (info.hasHabitaciones) spaces.add('Habitaciones (${info.cantidadHabitaciones})');
    if (info.hasBanos) spaces.add('Baños (${info.cantidadBanos})');
    if (info.hasOtros) spaces.add('Otros (${info.cantidadOtros})');
    
    return spaces.isEmpty ? 'Ninguno especificado' : spaces.join(', ');
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
    });

    try {
      final surveyState = Provider.of<SurveyState>(context, listen: false);
      
      // Convertir el estado de la encuesta a JSON
      final surveyData = surveyState.toJson();
      
      // Enviar usando el servicio de envío con sincronización automática
      await FormSubmissionService.submitSurveyForm(context, surveyData);
      
      print('✅ Formulario enviado exitosamente');
      
    } catch (e) {
      print('❌ Error enviando formulario: $e');
      
      // El servicio ya maneja el error y muestra el diálogo correspondiente
      
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
