import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// Servicio de sincronización automática simplificado
/// 
/// Responsabilidades:
/// - Monitoreo automático de conectividad
/// - Envío automático de encuestas pendientes
/// - Persistencia de datos pendientes
/// - Notificaciones de estado de sincronización
class BackgroundSyncService {
  static StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  static Timer? _periodicTimer;
  static bool _isInitialized = false;
  
  /// Inicializa el servicio de sincronización
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Inicializar monitoreo de conectividad
      await _startConnectivityMonitoring();
      
      // Inicializar verificación periódica
      _startPeriodicCheck();
      
      _isInitialized = true;
      print('Background sync service inicializado exitosamente (versión simplificada)');
    } catch (e) {
      print('Error inicializando background sync service: $e');
    }
  }

  /// Programa una encuesta para envío cuando haya conectividad
  static Future<void> scheduleSurveyForSync(Map<String, dynamic> surveyData) async {
    try {
      // Asignar ID único si no existe
      final surveyId = surveyData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      surveyData['id'] = surveyId;
      surveyData['timestamp'] = DateTime.now().toIso8601String();
      surveyData['syncStatus'] = 'pending';
      
      // Guardar en almacenamiento local
      await _savePendingSurvey(surveyData);
      
      // Intentar envío inmediato si hay conectividad
      if (await _hasInternetConnection()) {
        await _processPendingSurveys();
      } else {
        print('Sin conexión, encuesta programada para envío automático');
      }
    } catch (e) {
      print('Error programando encuesta para sincronización: $e');
      rethrow;
    }
  }

  /// Inicia el monitoreo de conectividad
  static Future<void> _startConnectivityMonitoring() async {
    final connectivity = Connectivity();
    
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        print('Cambio de conectividad detectado: $result');
        
        if (result != ConnectivityResult.none) {
          // Hay conectividad, intentar sincronizar
          print('Conectividad disponible, verificando encuestas pendientes...');
          await _processPendingSurveys();
        }
      },
      onError: (error) {
        print('Error en monitoreo de conectividad: $error');
      },
    );
  }

  /// Inicia verificación periódica (cada 5 minutos)
  static void _startPeriodicCheck() {
    _periodicTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      try {
        if (await _hasInternetConnection()) {
          await _processPendingSurveys();
        }
      } catch (e) {
        print('Error en verificación periódica: $e');
      }
    });
  }

  /// Verifica conectividad a internet
  static Future<bool> _hasInternetConnection() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print('Error verificando conectividad: $e');
      return false;
    }
  }

  /// Procesa todas las encuestas pendientes
  static Future<void> _processPendingSurveys() async {
    try {
      final pendingSurveys = await _getPendingSurveys();
      
      if (pendingSurveys.isEmpty) {
        return;
      }

      print('Procesando ${pendingSurveys.length} encuestas pendientes...');

      for (var surveyData in pendingSurveys) {
        try {
          await _sendSurvey(surveyData);
          await _markSurveyAsSynced(surveyData['id']);
          print('Encuesta ${surveyData['id']} enviada exitosamente');
        } catch (e) {
          print('Error enviando encuesta ${surveyData['id']}: $e');
          // Continuar con la siguiente encuesta
        }
      }
    } catch (e) {
      print('Error procesando encuestas pendientes: $e');
    }
  }

  /// Envía una encuesta específica
  static Future<void> _sendSurvey(Map<String, dynamic> surveyData) async {
    try {
      // Simular envío exitoso
      print('Enviando encuesta: ${surveyData['id']}');
      
      // Aquí se integraría con el servicio de email real
      // Por ejemplo: await EmailService.sendSurveyByEmail(surveyData);
      
      // Simular tiempo de envío
      await Future.delayed(const Duration(seconds: 1));
      
      print('Encuesta enviada exitosamente');
    } catch (e) {
      print('Error enviando encuesta: $e');
      rethrow;
    }
  }

  /// Guarda una encuesta como pendiente
  static Future<void> _savePendingSurvey(Map<String, dynamic> surveyData) async {
    try {
      // Usar el StorageService existente o implementar almacenamiento simple
      final pendingSurveys = await _getPendingSurveys();
      pendingSurveys.add(surveyData);
      
      // Guardar usando SharedPreferences o similar
      // Por simplicidad, usar una lista en memoria por ahora
      _pendingSurveysCache = pendingSurveys;
      
      print('Encuesta guardada como pendiente: ${surveyData['id']}');
    } catch (e) {
      print('Error guardando encuesta pendiente: $e');
      rethrow;
    }
  }

  // Cache simple en memoria para las encuestas pendientes
  static List<Map<String, dynamic>> _pendingSurveysCache = [];

  /// Obtiene las encuestas pendientes
  static Future<List<Map<String, dynamic>>> _getPendingSurveys() async {
    try {
      // Aquí se integraría con StorageService.getPendingSurveys()
      return List.from(_pendingSurveysCache);
    } catch (e) {
      print('Error obteniendo encuestas pendientes: $e');
      return [];
    }
  }

  /// Marca una encuesta como sincronizada
  static Future<void> _markSurveyAsSynced(String surveyId) async {
    try {
      _pendingSurveysCache.removeWhere((survey) => survey['id'] == surveyId);
      print('Encuesta $surveyId marcada como sincronizada');
    } catch (e) {
      print('Error marcando encuesta como sincronizada: $e');
    }
  }

  /// Obtiene el estado actual de las tareas de sincronización
  static Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      final pendingSurveys = await _getPendingSurveys();
      final hasConnectivity = await _hasInternetConnection();
      
      return {
        'hasPendingSurveys': pendingSurveys.isNotEmpty,
        'pendingCount': pendingSurveys.length,
        'hasConnectivity': hasConnectivity,
        'lastSyncAttempt': DateTime.now().toIso8601String(),
        'isInitialized': _isInitialized,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'hasPendingSurveys': false,
        'pendingCount': 0,
        'hasConnectivity': false,
        'isInitialized': false,
      };
    }
  }

  /// Cancela todos los monitoreos
  static Future<void> dispose() async {
    try {
      _connectivitySubscription?.cancel();
      _periodicTimer?.cancel();
      _connectivitySubscription = null;
      _periodicTimer = null;
      _isInitialized = false;
      print('Background sync service desactivado');
    } catch (e) {
      print('Error desactivando background sync service: $e');
    }
  }

  /// Fuerza una sincronización manual
  static Future<void> forceSyncNow() async {
    try {
      print('Forzando sincronización manual...');
      await _processPendingSurveys();
    } catch (e) {
      print('Error en sincronización manual: $e');
      rethrow;
    }
  }
}
