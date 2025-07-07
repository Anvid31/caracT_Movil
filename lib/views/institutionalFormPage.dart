import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/institutionalInfo.dart';
import '../models/survey_state.dart';
import '../widgets/form/index.dart';
import '../widgets/layout/enhanced_form_container.dart';
import '../utils/form_navigator.dart';
import 'coverageFormPage.dart';

class InstitutionalFormPage extends StatefulWidget {
  const InstitutionalFormPage({super.key});

  @override
  State<InstitutionalFormPage> createState() => _InstitutionalFormPageState();
}

class _InstitutionalFormPageState extends State<InstitutionalFormPage> {
  final _formKey = GlobalKey<FormState>();
  late InstitutionalInfo _institutionalInfo;
  bool _showErrors = false;
  
  // Agregar controllers
  final _institutionNameController = TextEditingController();
  final _headquartersController = TextEditingController();
  final _principalNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final surveyState = Provider.of<SurveyState>(context, listen: false);
    _institutionalInfo = surveyState.institutionalInfo;
    
    // Inicializar controllers
    _institutionNameController.text = _institutionalInfo.institutionName ?? '';
    _headquartersController.text = _institutionalInfo.educationalHeadquarters ?? '';
    _principalNameController.text = _institutionalInfo.principalName ?? '';
    _contactController.text = _institutionalInfo.contact ?? '';
    _emailController.text = _institutionalInfo.email ?? '';
  }

  @override
  void dispose() {
    _institutionNameController.dispose();
    _headquartersController.dispose();
    _principalNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }  @override
  Widget build(BuildContext context) {
    return EnhancedFormContainer(
      title: 'Información Institucional',
      subtitle: 'Datos de la institución educativa',
      currentStep: 2,
      onPrevious: () => FormNavigator.popForm(context),
      onNext: _submitForm,
      transitionType: FormTransitionType.slideScale,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        const Color(0xFF2196F3).withValues(alpha: 0.1),
                        const Color(0xFF2196F3).withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 32,
                        color: Color(0xFF2196F3),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Información Institucional',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Datos básicos de la institución educativa y sus responsables',
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
                  label: 'Nombre de la Institución Educativa - Principal',
                  controller: _institutionNameController,
                  onChanged: (value) => _institutionalInfo.institutionName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Nombre Sede Educativa',
                  controller: _headquartersController,
                  onChanged: (value) => _institutionalInfo.educationalHeadquarters = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                LocationField(
                  label: 'Ubicación geográfica de la sede educativa (Coordenadas) - Oprima el botón para adquirir ubicación',
                  initialValue: _institutionalInfo.location,
                  onChanged: (value) => _institutionalInfo.location = value,
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Nombre del Rector',
                  controller: _principalNameController,
                  onChanged: (value) => _institutionalInfo.principalName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Contacto',
                  keyboardType: TextInputType.phone,
                  controller: _contactController,
                  onChanged: (value) => _institutionalInfo.contact = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  onChanged: (value) => _institutionalInfo.email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    if (!value.contains('@')) {
                      return 'Ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _submitForm() {
    setState(() {
      _showErrors = true;
    });

    if (_formKey.currentState!.validate()) {
      Provider.of<SurveyState>(context, listen: false)
          .updateInstitutionalInfo(_institutionalInfo);
      
      // Usar el nuevo sistema de navegación con transiciones
      FormNavigator.pushForm(
        context,
        const CoverageFormPage(),
        type: FormTransitionType.slideScale,
        stepNumber: 3,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos requeridos'),
          backgroundColor: Color(0xFFD32F2F),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }
}
