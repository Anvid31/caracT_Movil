import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/photographic_record_info.dart';
import '../models/survey_state.dart';
import '../widgets/layout/form_container.dart';
import '../widgets/form/photo_capture_field_temp.dart';
import '../services/storage_service.dart';
import '../utils/form_navigator.dart';
import 'observationsFormPage.dart';

class PhotographicRecordPage extends StatefulWidget {
  const PhotographicRecordPage({super.key});

  @override
  State<PhotographicRecordPage> createState() => _PhotographicRecordPageState();
}

class _PhotographicRecordPageState extends State<PhotographicRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late PhotographicRecordInfo _photographicRecordInfo;
  bool _showErrors = false;
  @override
  void initState() {
    super.initState();
    final surveyState = Provider.of<SurveyState>(context, listen: false);
    _photographicRecordInfo = surveyState.photographicRecordInfo;
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    try {
      final existingData = await StorageService.getPhotographicRecordInfo();
      if (existingData != null && mounted) {
        setState(() {
          _photographicRecordInfo = existingData;
        });
        // Actualizar también el estado global
        Provider.of<SurveyState>(context, listen: false)
            .updatePhotographicRecordInfo(existingData);
      }    } catch (e) {
      print('Error al cargar datos del registro fotográfico: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      await StorageService.savePhotographicRecordInfo(_photographicRecordInfo);
      Provider.of<SurveyState>(context, listen: false)
          .updatePhotographicRecordInfo(_photographicRecordInfo);
    } catch (e) {
      print('Error al guardar datos del registro fotográfico: $e');
    }
  }  @override
  Widget build(BuildContext context) {
    return FormContainer(
      title: 'Registro Fotográfico',
      currentStep: 8,
      onPrevious: () => Navigator.pop(context),
      onNext: _submitForm,
      child: Form(
        key: _formKey,
        autovalidateMode: _showErrors 
            ? AutovalidateMode.always 
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Caja informativa con descripción
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF795548).withValues(alpha: 0.1),
                    const Color(0xFF795548).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF795548).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                    color: Color(0xFF795548),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Registro Fotográfico',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Capture fotografías de los diferentes espacios de la sede educativa',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),            ),
            const SizedBox(height: 24),

            // Sección: Fotografías Externas
            _buildSectionHeader('Fotografías Externas', Icons.domain_outlined),
            const SizedBox(height: 16),
              PhotoCaptureField(
              label: 'Frente de la Escuela',
              hintText: 'Captura la fachada principal de la institución',              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.frontSchoolPhoto = imagePath;
                });
                _saveData();
              },
              imagePath: _photographicRecordInfo.frontSchoolPhoto,
            ),
            const SizedBox(height: 20),
              PhotoCaptureField(
              label: 'Vista General del Predio',
              hintText: 'Toma una foto panorámica del terreno',              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.generalPhoto = imagePath;
                });
                _saveData();
              },
              imagePath: _photographicRecordInfo.generalPhoto,
            ),
            const SizedBox(height: 24),

            // Sección: Espacios Interiores
            _buildSectionHeader('Espacios Interiores', Icons.meeting_room_outlined),
            const SizedBox(height: 16),
            
            PhotoCaptureField(
              label: 'Salones de Clase',
              hintText: 'Fotografía de uno o varios salones',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.classroomsPhoto = imagePath;
                });
              },
              imagePath: _photographicRecordInfo.classroomsPhoto,
            ),
            const SizedBox(height: 20),
            
            PhotoCaptureField(
              label: 'Cocina',
              hintText: 'Área de preparación de alimentos',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.kitchenPhoto = imagePath;
                });
              },
              imagePath: _photographicRecordInfo.kitchenPhoto,
            ),
            const SizedBox(height: 20),
            
            PhotoCaptureField(
              label: 'Comedor',
              hintText: 'Espacio destinado para comer',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.diningRoomPhoto = imagePath;
                });
              },
              imagePath: _photographicRecordInfo.diningRoomPhoto,
            ),
            const SizedBox(height: 24),

            // Sección: Infraestructura
            _buildSectionHeader('Infraestructura y Servicios', Icons.build_outlined),
            const SizedBox(height: 16),
            
            PhotoCaptureField(
              label: 'Infraestructura General',
              hintText: 'Estado general de las instalaciones',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.infrastructurePhoto = imagePath;
                });
              },
              imagePath: _photographicRecordInfo.infrastructurePhoto,
            ),
            const SizedBox(height: 20),
            
            PhotoCaptureField(
              label: 'Sistema Eléctrico',
              hintText: 'Tableros, cableado, paneles solares, etc.',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.electricityPhoto = imagePath;
                });
              },
              imagePath: _photographicRecordInfo.electricityPhoto,
            ),
            const SizedBox(height: 24),

            // Sección: Entorno
            _buildSectionHeader('Entorno y Observaciones', Icons.nature_people_outlined),
            const SizedBox(height: 16),
            
            PhotoCaptureField(
              label: 'Entorno Natural',
              hintText: 'Paisaje, acceso, condiciones ambientales',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.environmentPhoto = imagePath;
                });
              },
              imagePath: _photographicRecordInfo.environmentPhoto,
            ),
            const SizedBox(height: 20),
            
            PhotoCaptureField(
              label: 'Fotografías Adicionales',
              hintText: 'Otros aspectos relevantes (opcional)',
              onImageSelected: (imagePath) {
                setState(() {
                  _photographicRecordInfo.additionalPhotos = imagePath;
                });
              },              imagePath: _photographicRecordInfo.additionalPhotos,
            ),
            const SizedBox(height: 32),

            // Resumen de fotos capturadas
            _buildPhotoSummary(),
          ],
        ),
      ),
    );
  }  void _submitForm() async {
    setState(() {
      _showErrors = true;
    });

    try {
      // Guardar la información del registro fotográfico en el estado
      Provider.of<SurveyState>(context, listen: false)
          .updatePhotographicRecordInfo(_photographicRecordInfo);
      
      // Guardar en almacenamiento local
      await StorageService.savePhotographicRecordInfo(_photographicRecordInfo);
      
      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro fotográfico guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
        // Navegar a la página de observaciones (paso final)
      if (mounted) {
        // Usar el nuevo sistema de navegación con transiciones suaves
        FormNavigator.pushForm(
          context,
          const ObservationsFormPage(),
          type: FormTransitionType.slideScale,
          stepNumber: 9,
        );
      }
    } catch (e) {
      // Mostrar error si ocurre algún problema
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar registro fotográfico: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF795548).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF795548),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        Container(
          height: 1,
          width: 50,
          color: Colors.grey.shade300,
        ),      ],
    );
  }

  Widget _buildPhotoSummary() {
    final capturedPhotos = [
      if (_photographicRecordInfo.frontSchoolPhoto?.isNotEmpty == true) 'Frente de la Escuela',
      if (_photographicRecordInfo.generalPhoto?.isNotEmpty == true) 'Vista General',
      if (_photographicRecordInfo.classroomsPhoto?.isNotEmpty == true) 'Salones de Clase',
      if (_photographicRecordInfo.kitchenPhoto?.isNotEmpty == true) 'Cocina',
      if (_photographicRecordInfo.diningRoomPhoto?.isNotEmpty == true) 'Comedor',
      if (_photographicRecordInfo.infrastructurePhoto?.isNotEmpty == true) 'Infraestructura',
      if (_photographicRecordInfo.electricityPhoto?.isNotEmpty == true) 'Sistema Eléctrico',
      if (_photographicRecordInfo.environmentPhoto?.isNotEmpty == true) 'Entorno Natural',
      if (_photographicRecordInfo.additionalPhotos?.isNotEmpty == true) 'Fotos Adicionales',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withValues(alpha: 0.1),
            const Color(0xFF4CAF50).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.photo_camera,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Resumen del Registro Fotográfico',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Fotografías capturadas: ${capturedPhotos.length} de 9 posibles',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (capturedPhotos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: capturedPhotos.map((photo) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      photo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
