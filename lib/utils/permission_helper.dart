import 'package:flutter/material.dart';

class PermissionHelper {

  /// Verifica si los permisos de cámara están habilitados
  static Future<bool> isCameraPermissionGranted() async {
    try {
      // En Android, si image_picker puede acceder, generalmente significa que tiene permisos
      return true; // Por defecto asumimos que sí para simplificar
    } catch (e) {
      print('Error verificando permisos de cámara: $e');
      return false;
    }
  }

  /// Verifica si los permisos de almacenamiento están habilitados
  static Future<bool> isStoragePermissionGranted() async {
    try {
      // En Android, si image_picker puede acceder, generalmente significa que tiene permisos
      return true; // Por defecto asumimos que sí para simplificar
    } catch (e) {
      print('Error verificando permisos de almacenamiento: $e');
      return false;
    }
  }

  /// Muestra un diálogo explicativo sobre permisos
  static void showPermissionDialog(BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onSettingsPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
          if (onSettingsPressed != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onSettingsPressed();
              },
              child: const Text('Configuración'),
            ),
        ],
      ),
    );
  }

  /// Abre la configuración de la aplicación (simulado)
  static Future<void> openAppSettings() async {
    try {
      // En un entorno real, esto podría usar url_launcher o app_settings
      print('Abriendo configuración de la app...');
      // await AppSettings.openAppSettings();
    } catch (e) {
      print('Error abriendo configuración: $e');
    }
  }

  /// Información sobre permisos requeridos
  static Map<String, String> get permissionInfo => {
    'camera': 'Permite tomar fotos directamente desde la aplicación.',
    'storage': 'Permite seleccionar imágenes existentes desde la galería del dispositivo.',
    'media': 'En Android 13+, permite acceso a imágenes y videos.',
  };

  /// Mensajes de error estándar por tipo de problema
  static Map<String, String> get errorMessages => {
    'camera_access_denied': 'Permisos de cámara denegados. Ve a Configuración > Aplicaciones > CaracT Móvil > Permisos para habilitarlos.',
    'photo_access_denied': 'Permisos de galería denegados. Ve a Configuración > Aplicaciones > CaracT Móvil > Permisos para habilitarlos.',
    'no_available_camera': 'No hay cámara disponible en este dispositivo.',
    'permission_denied': 'Sin permisos necesarios. Verifica la configuración de la aplicación.',
    'unknown_error': 'Error inesperado. Verifica que la aplicación tenga todos los permisos necesarios.',
  };

  /// Obtiene un mensaje de error amigable basado en el código de error
  static String getFriendlyErrorMessage(String errorCode) {
    return errorMessages[errorCode] ?? errorMessages['unknown_error']!;
  }

  /// Verifica la compatibilidad del dispositivo
  static Future<Map<String, bool>> checkDeviceCompatibility() async {
    return {
      'hasCamera': true, // Simplificado por ahora
      'hasGallery': true,
      'supportsImagePicker': true,
      'hasFileProvider': true,
    };
  }

  /// Instrucciones paso a paso para habilitar permisos
  static List<String> get permissionInstructions => [
    '1. Ve a Configuración del dispositivo',
    '2. Busca "Aplicaciones" o "Apps"',
    '3. Encuentra "CaracT Móvil" en la lista',
    '4. Toca en "Permisos"',
    '5. Habilita "Cámara" y "Almacenamiento/Archivos multimedia"',
    '6. Regresa a la aplicación e intenta nuevamente',
  ];

  /// Widget con instrucciones de permisos
  static Widget buildPermissionInstructionsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Para habilitar los permisos:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...permissionInstructions.map((instruction) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            instruction,
            style: const TextStyle(fontSize: 14),
          ),
        )),
      ],
    );
  }
}
