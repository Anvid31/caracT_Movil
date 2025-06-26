import 'package:connectivity_plus/connectivity_plus.dart';
import 'storage_service.dart';

class SyncService {
  static final Connectivity _connectivity = Connectivity();
  
  static Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Future<void> syncPendingSurveys() async {
    if (!await hasInternetConnection()) {
      return;
    }

    final pendingSurveys = await StorageService.getPendingSurveys();
    
    for (var survey in pendingSurveys) {
      try {
        // TO DO: Implementar la llamada a la API para enviar los datos
        // await apiService.sendSurvey(survey);
        
        await StorageService.markSurveyAsSynced(survey['id']);
      } catch (e) {
        print('Error syncing survey ${survey['id']}: $e');
      }
    }
  }

  static Stream<ConnectivityResult> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }
}
