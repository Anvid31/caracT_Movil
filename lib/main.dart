import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/survey_state.dart';
import 'views/splash_screen.dart';
import 'config/theme.dart';
import 'services/storage_service.dart';
import 'services/auto_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
    print('Variables de entorno cargadas exitosamente');
  } catch (e) {
    print('Advertencia: No se pudo cargar el archivo .env: $e');
    print('Cree un archivo .env basado en .env.example para configurar las credenciales');
  }
  
  try {
    await StorageService.init();
    print('Hive inicializado exitosamente');
  } catch (e) {
    print('Error al inicializar Hive: $e');
  }
  
  try {
    await AutoSyncService.initialize();
    print('Servicio de sincronización automática inicializado');
  } catch (e) {
    print('Error al inicializar sincronización automática: $e');
  }
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
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
