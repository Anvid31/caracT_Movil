import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/survey_state.dart';
import 'views/splash_screen.dart';
import 'config/theme.dart';
import 'services/storage_service.dart';
import 'services/auto_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización robusta sin dependencias críticas
  try {
    await StorageService.init();
    print('Hive inicializado exitosamente');
  } catch (e) {
    print('Error al inicializar Hive: $e');
    // No detener la app si falla Storage
  }
  
  try {
    await AutoSyncService.initialize();
    print('Servicio de sincronización automática inicializado');
  } catch (e) {
    print('Error al inicializar sincronización automática: $e');
    // No detener la app si falla AutoSync
  }
  
  // Configurar orientación preferida
  try {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  } catch (e) {
    print('Error configurando orientación: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SurveyState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CENS App',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
