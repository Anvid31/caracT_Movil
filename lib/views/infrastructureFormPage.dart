import 'package:flutter/material.dart';
import '../models/infrastructureInfo.dart';
import '../services/storage_service.dart';
import '../widgets/layout/enhanced_form_container.dart';
import '../utils/form_navigator.dart';
import 'electricityFormPage.dart';

class InfrastructureFormPage extends StatefulWidget {
  const InfrastructureFormPage({super.key});

  @override
  State<InfrastructureFormPage> createState() => _InfrastructureFormPageState();
}

class _InfrastructureFormPageState extends State<InfrastructureFormPage> {
  final _formKey = GlobalKey<FormState>();
  late InfrastructureInfo infrastructureInfo;
  final TextEditingController _proyectosController = TextEditingController();
  final TextEditingController _otrosEspaciosController = TextEditingController();
  final TextEditingController _otroPredioController = TextEditingController();
  bool _showErrors = false;
  
  @override
  void initState() {
    super.initState();
    // Siempre inicializar con datos limpios
    infrastructureInfo = InfrastructureInfo();
    _proyectosController.clear();
    _otrosEspaciosController.clear();
    _otroPredioController.clear();
    
    // Limpiar cualquier dato persistente del almacenamiento
    _clearStorageData();
  }
  Future<void> _clearStorageData() async {
    try {
      await StorageService.clearInfrastructureData();
      // Datos del almacenamiento limpiados
    } catch (e) {
      print('Error al limpiar datos del almacenamiento: $e');
    }
  }

  Future<void> _clearFormData() async {
    // Mostrar diálogo de confirmación
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Limpiar Formulario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            '¿Está seguro de que desea limpiar todos los datos del formulario? Esta acción no se puede deshacer.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Limpiar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await StorageService.clearInfrastructureData();
        setState(() {
          infrastructureInfo = InfrastructureInfo();
          _proyectosController.clear();
          _otrosEspaciosController.clear();
          _otroPredioController.clear();
          _showErrors = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Formulario limpiado correctamente'),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        
        // Formulario y datos del almacenamiento limpiados
      } catch (e) {
        print('Error al limpiar formulario: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error al limpiar el formulario'),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    }
  }
  Future<void> _saveData() async {
    setState(() {
      _showErrors = true;
    });

    // Validar que se haya seleccionado una opción de propiedad del predio
    bool isValid = _formKey.currentState!.validate();
    
    if (infrastructureInfo.propiedadPredio.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Por favor, seleccione la propiedad del predio'),
            ],
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    if (isValid) {
      infrastructureInfo.proyectosInfraestructura = _proyectosController.text;
      infrastructureInfo.descripcionOtrosEspacios = _otrosEspaciosController.text;
      infrastructureInfo.descripcionOtroPredio = _otroPredioController.text;
      try {        await StorageService.saveInfrastructureInfo(infrastructureInfo);
        if (mounted) {
          // Usar el nuevo sistema de navegación con transiciones suaves
          FormNavigator.pushForm(
            context,
            const ElectricityFormPage(),
            type: FormTransitionType.slideScale,
            stepNumber: 5,
          );
        }
      } catch (e) {
        print('Error al guardar datos: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error al guardar los datos'),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    }
  }  @override
  Widget build(BuildContext context) {
    return EnhancedFormContainer(
      title: 'Infraestructura',
      subtitle: 'Información sobre espacios y proyectos',
      currentStep: 4,
      onPrevious: () => FormNavigator.popForm(context),
      onNext: _saveData,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,              children: [                
                // Header con descripción dentro de Stack para botón flotante
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withValues(alpha: 0.1),
                            Colors.indigo.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.business,
                            size: 32,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Infraestructura Educativa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E2E2E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Información sobre espacios, proyectos y propiedad de la sede educativa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),                    // Botón de limpiar en la esquina superior derecha
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),                        child: InkWell(
                          onTap: _clearFormData,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.blue.shade700,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Limpiar',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Sección de espacios disponibles
                _buildSpacesSection(),
                
                const SizedBox(height: 32),
                
                // Sección de proyectos de infraestructura
                _buildProjectsSection(),
                
                const SizedBox(height: 32),
                
                // Sección de propiedad del predio
                _buildPropertySection(),
                
                const SizedBox(height: 80), // Espacio para los botones fijos
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpacesSection() {
    final spaces = [
      {'key': 'hasSalones', 'title': 'Salones', 'icon': Icons.school},
      {'key': 'hasComedor', 'title': 'Comedor', 'icon': Icons.restaurant},
      {'key': 'hasCocina', 'title': 'Cocina', 'icon': Icons.kitchen},
      {'key': 'hasSalonReuniones', 'title': 'Salón para reuniones', 'icon': Icons.meeting_room},
      {'key': 'hasHabitaciones', 'title': 'Habitaciones', 'icon': Icons.bed},
      {'key': 'hasBanos', 'title': 'Baños', 'icon': Icons.wc},
      {'key': 'hasOtros', 'title': 'Otros espacios', 'icon': Icons.more_horiz},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.domain,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Espacios Disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de espacios
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marque los espacios con los que cuenta la sede educativa:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ...spaces.map((space) => _buildSpaceCheckbox(space)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceCheckbox(Map<String, dynamic> space) {
    bool getValue() {
      switch (space['key']) {
        case 'hasSalones': return infrastructureInfo.hasSalones;
        case 'hasComedor': return infrastructureInfo.hasComedor;
        case 'hasCocina': return infrastructureInfo.hasCocina;
        case 'hasSalonReuniones': return infrastructureInfo.hasSalonReuniones;
        case 'hasHabitaciones': return infrastructureInfo.hasHabitaciones;
        case 'hasBanos': return infrastructureInfo.hasBanos;
        case 'hasOtros': return infrastructureInfo.hasOtros;
        default: return false;
      }
    }

    int getQuantity() {
      switch (space['key']) {
        case 'hasSalones': return infrastructureInfo.cantidadSalones;
        case 'hasComedor': return infrastructureInfo.cantidadComedor;
        case 'hasCocina': return infrastructureInfo.cantidadCocina;
        case 'hasSalonReuniones': return infrastructureInfo.cantidadSalonReuniones;
        case 'hasHabitaciones': return infrastructureInfo.cantidadHabitaciones;
        case 'hasBanos': return infrastructureInfo.cantidadBanos;
        case 'hasOtros': return infrastructureInfo.cantidadOtros;
        default: return 0;
      }
    }

    void setValue(bool value) {
      setState(() {
        switch (space['key']) {
          case 'hasSalones': 
            infrastructureInfo.hasSalones = value;
            if (!value) infrastructureInfo.cantidadSalones = 0;
            break;
          case 'hasComedor': 
            infrastructureInfo.hasComedor = value;
            if (!value) infrastructureInfo.cantidadComedor = 0;
            break;
          case 'hasCocina': 
            infrastructureInfo.hasCocina = value;
            if (!value) infrastructureInfo.cantidadCocina = 0;
            break;
          case 'hasSalonReuniones': 
            infrastructureInfo.hasSalonReuniones = value;
            if (!value) infrastructureInfo.cantidadSalonReuniones = 0;
            break;
          case 'hasHabitaciones': 
            infrastructureInfo.hasHabitaciones = value;
            if (!value) infrastructureInfo.cantidadHabitaciones = 0;
            break;
          case 'hasBanos': 
            infrastructureInfo.hasBanos = value;
            if (!value) infrastructureInfo.cantidadBanos = 0;
            break;
          case 'hasOtros': 
            infrastructureInfo.hasOtros = value;
            if (!value) {
              infrastructureInfo.cantidadOtros = 0;
              _otrosEspaciosController.clear();
              infrastructureInfo.descripcionOtrosEspacios = '';
            }
            break;
        }
      });
    }

    void setQuantity(int quantity) {
      setState(() {
        switch (space['key']) {
          case 'hasSalones': infrastructureInfo.cantidadSalones = quantity; break;
          case 'hasComedor': infrastructureInfo.cantidadComedor = quantity; break;
          case 'hasCocina': infrastructureInfo.cantidadCocina = quantity; break;
          case 'hasSalonReuniones': infrastructureInfo.cantidadSalonReuniones = quantity; break;
          case 'hasHabitaciones': infrastructureInfo.cantidadHabitaciones = quantity; break;
          case 'hasBanos': infrastructureInfo.cantidadBanos = quantity; break;
          case 'hasOtros': infrastructureInfo.cantidadOtros = quantity; break;
        }
      });
    }

    final isSelected = getValue();
    final quantity = getQuantity();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? Colors.green 
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected 
            ? Colors.green.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setValue(!isSelected),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected 
                            ? Colors.green 
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected 
                          ? Colors.green 
                          : Colors.white,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    space['icon'],
                    color: isSelected 
                        ? Colors.green 
                        : Colors.grey.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      space['title'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: isSelected 
                            ? Colors.green.shade700 
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Campo de cantidad - aparece cuando está seleccionado
          if (isSelected) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.green.withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 32), // Alineación con el contenido superior
                  Icon(
                    Icons.numbers,
                    color: Colors.green.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cantidad:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          // Botón disminuir
                          InkWell(
                            onTap: quantity > 0 ? () => setQuantity(quantity - 1) : null,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: quantity > 0 
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: quantity > 0 
                                    ? Colors.green.shade600
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                          
                          // Campo numérico
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                          
                          // Botón aumentar
                          InkWell(
                            onTap: () => setQuantity(quantity + 1),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.green.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Campo de descripción para "Otros espacios"
          if (isSelected && space['key'] == 'hasOtros') ...[
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.green.withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      Icon(
                        Icons.description,
                        color: Colors.green.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Especifique otros espacios:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(left: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _otrosEspaciosController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Ej: Biblioteca, laboratorio, auditorio, etc.',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.construction,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Proyectos de Infraestructura',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Campo de texto
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mencione si existen proyectos de infraestructura que se estén ejecutando:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade50,
                  ),
                  child: TextFormField(
                    controller: _proyectosController,
                    maxLines: 4,
                    minLines: 3,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ej: Canchas deportivas, nuevos baños, ampliación de salones, mejora del comedor, cocina escolar, etc.\n\nIndique también qué entidad está realizando estos proyectos.',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertySection() {
    final propertyOptions = [
      {'value': 'Municipio', 'icon': Icons.location_city},
      {'value': 'Junta de acción comunal', 'icon': Icons.groups},
      {'value': 'Privado', 'icon': Icons.person},
      {'value': 'Otro', 'icon': Icons.help_outline},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.home_work,
                    color: Colors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Propiedad del Predio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
            // Opciones de propiedad
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'El predio donde se encuentra la sede educativa es de propiedad de:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_showErrors && infrastructureInfo.propiedadPredio.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Este campo es obligatorio',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                ...propertyOptions.map((option) => _buildPropertyOption(option)).toList(),
                
                // Campo de texto para "Otro"
                if (infrastructureInfo.propiedadPredio == 'Otro') ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade300),
                      color: Colors.purple.withValues(alpha: 0.05),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.purple.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Especifique la propiedad del predio:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple.shade300),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _otroPredioController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Ej: Iglesia, fundación, cooperativa, etc.',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyOption(Map<String, dynamic> option) {
    final isSelected = infrastructureInfo.propiedadPredio == option['value'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? Colors.purple 
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected 
            ? Colors.purple.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            infrastructureInfo.propiedadPredio = option['value'];
            // Limpiar el campo "Otro" si se selecciona una opción diferente
            if (option['value'] != 'Otro') {
              _otroPredioController.clear();
              infrastructureInfo.descripcionOtroPredio = '';
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? Colors.purple 
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: isSelected 
                      ? Colors.purple 
                      : Colors.white,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Icon(
                option['icon'],
                color: isSelected 
                    ? Colors.purple 
                    : Colors.grey.shade400,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  option['value'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                    color: isSelected 
                        ? Colors.purple.shade700 
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _proyectosController.dispose();
    _otrosEspaciosController.dispose();
    _otroPredioController.dispose();
    super.dispose();
  }
}
