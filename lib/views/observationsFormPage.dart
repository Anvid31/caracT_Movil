import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/observationsInfo.dart';
import '../models/survey_state.dart';
import '../services/xml_export_service.dart';
import '../services/email_service.dart';
import '../widgets/form/custom_text_field.dart';
import '../widgets/form/form_header.dart';
import '../widgets/layout/rounded_container.dart';

class ObservationsFormPage extends StatefulWidget {
  const ObservationsFormPage({super.key});

  @override
  State<ObservationsFormPage> createState() => _ObservationsFormPageState();
}

class _ObservationsFormPageState extends State<ObservationsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _observationsInfo = ObservationsInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: SafeArea(
        child: Column(
          children: [
            const FormHeader(
              title: 'Observaciones Finales',
              currentStep: 9,
              totalSteps: 9,
              subtitle: 'Último paso - Complete la caracterización',
            ),
            Expanded(
              child: RoundedContainer(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,                    child: Column(
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
                          onChanged: (value) => _observationsInfo.additionalObservations = value,
                          maxLines: 5,
                        ),
                        const SizedBox(height: 32),
                        
                        // Botón de envío final con diseño especial
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _submitForm,
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Finalizar y Enviar Caracterización',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Obtener el estado completo de la encuesta
      final surveyState = Provider.of<SurveyState>(context, listen: false);
      
      // Actualizar las observaciones
      surveyState.updateObservationsInfo(_observationsInfo);
      
      // Mostrar diálogo de opciones de envío
      _showExportOptionsDialog(surveyState);
    }
  }
  
  void _showExportOptionsDialog(SurveyState surveyState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.send_rounded, color: Color(0xFF4CAF50)),
            SizedBox(width: 8),
            Text('Enviar Formulario'),
          ],
        ),
        content: const Text(
          '¿Cómo desea enviar la información recopilada?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _generateAndShareZip(surveyState);
            },
            icon: const Icon(Icons.share),
            label: const Text('Compartir'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _showEmailDialog(surveyState);
            },
            icon: const Icon(Icons.email),
            label: const Text('Email'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _generateAndSaveZip(surveyState);
            },
            icon: const Icon(Icons.download),
            label: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
  
  void _generateAndShareZip(SurveyState surveyState) async {
    _showLoadingDialog('Generando archivo...');
    
    try {
      final zipFile = await XmlExportService.createSurveyPackage(surveyState);
      Navigator.of(context).pop(); // Cerrar loading
      
      if (zipFile != null) {
        await EmailService.shareZipFile(
          zipFile, 
          institutionName: surveyState.institutionalInfo.institutionName
        );
        _showSuccessDialog('Archivo generado exitosamente');
      } else {
        _showErrorDialog('Error al generar el archivo');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar loading
      _showErrorDialog('Error: $e');
    }
  }
  
  void _generateAndSaveZip(SurveyState surveyState) async {
    _showLoadingDialog('Guardando archivo...');
    
    try {
      final zipFile = await XmlExportService.createSurveyPackage(surveyState);
      Navigator.of(context).pop(); // Cerrar loading
      
      if (zipFile != null) {
        final savedFile = await EmailService.copyToDownloads(
          zipFile, 
          institutionName: surveyState.institutionalInfo.institutionName
        );
        
        if (savedFile != null) {
          _showSuccessDialog('Archivo guardado en: ${savedFile.path}');
        } else {
          _showErrorDialog('Error al guardar el archivo');
        }
      } else {
        _showErrorDialog('Error al generar el archivo');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar loading
      _showErrorDialog('Error: $e');
    }
  }  void _showEmailDialog(SurveyState surveyState) {
    // Verificar si la configuración de correo está lista
    if (!EmailService.isEmailConfigured()) {
      _showConfigurationDialog();
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enviar por Correo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.email,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'La caracterización será enviada automáticamente al correo institucional configurado.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Destino: mendozadiazjuandavid@gmail.com',
              style: TextStyle(
                fontSize: 14, 
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Desea continuar con el envío?',
              style: TextStyle(fontWeight: FontWeight.bold),
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
              _sendByEmail(surveyState);
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
  
  void _showConfigurationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Configuración Requerida'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'El servicio de correo electrónico no está configurado.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Para enviar caracterizaciones por correo, debe configurar las credenciales en:',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'lib/config/email_config.dart',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Consulte el archivo para instrucciones detalladas de configuración.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
  
  void _sendByEmail(SurveyState surveyState) async {
    _showLoadingDialog('Enviando por correo...');
    
    try {
      final zipFile = await XmlExportService.createSurveyPackage(surveyState);
      
      if (zipFile != null) {
        final success = await EmailService.sendSurveyQuick(zipFile, surveyState);
        
        Navigator.of(context).pop(); // Cerrar loading
        
        if (success) {
          _showSuccessDialog('Correo enviado exitosamente al sistema de caracterización');
        } else {
          _showErrorDialog('Error al enviar el correo. Verifique la configuración del servicio.');
        }
      } else {
        Navigator.of(context).pop(); // Cerrar loading
        _showErrorDialog('Error al generar el archivo');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar loading
      _showErrorDialog('Error: $e');
    }
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
  
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Éxito'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Aceptar'),
          ),
        ],
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
