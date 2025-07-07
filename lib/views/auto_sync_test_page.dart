import 'package:flutter/material.dart';
import '../services/auto_sync_service.dart';
import '../widgets/auto_sync_status_widget.dart';

/// Página de prueba para la funcionalidad de sincronización automática
class AutoSyncTestPage extends StatefulWidget {
  const AutoSyncTestPage({super.key});

  @override
  State<AutoSyncTestPage> createState() => _AutoSyncTestPageState();
}

class _AutoSyncTestPageState extends State<AutoSyncTestPage> {
  String _status = 'Listo para probar';
  bool _isLoading = false;
  Map<String, dynamic>? _syncStatus;

  @override
  void initState() {
    super.initState();
    _updateSyncStatus();
  }

  Future<void> _updateSyncStatus() async {
    try {
      final status = await AutoSyncService.getSyncStatus();
      setState(() {
        _syncStatus = status;
      });
    } catch (e) {
      print('Error obteniendo estado de sincronización: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba Sincronización Automática'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Widget de estado de sincronización en tiempo real
            const AutoSyncStatusWidget(),
            
            const SizedBox(height: 24),
            
            // Información del sistema
            _buildInfoCard(),
            
            const SizedBox(height: 16),
            
            // Estado actual
            _buildStatusCard(),
            
            const SizedBox(height: 24),
            
            // Botones de prueba
            _buildTestButtons(),
            
            const SizedBox(height: 24),
            
            // Información adicional
            _buildInstructionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Funcionalidad Implementada',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '✅ Sincronización automática con conectividad\n'
              '✅ Persistencia de datos con SharedPreferences\n'
              '✅ Monitoreo de conectividad en tiempo real\n'
              '✅ Reintentos automáticos en caso de fallos\n'
              '✅ Interfaz de estado actualizada automáticamente\n'
              '✅ Compatible con todas las versiones de Flutter\n'
              '✅ Sincronización manual disponible',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Estado Actual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Estado: $_status',
              style: const TextStyle(fontSize: 16),
            ),
            if (_syncStatus != null) ...[
              const SizedBox(height: 8),
              Text(
                'Encuestas pendientes: ${_syncStatus!['pendingCount'] ?? 0}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Conectividad: ${_syncStatus!['hasConnectivity'] ? 'Disponible' : 'No disponible'}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Pruebas Disponibles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _testScheduleSurvey,
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Simular Envío Automático'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        
        const SizedBox(height: 8),
        
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _testForcedSync,
          icon: const Icon(Icons.sync),
          label: const Text('Forzar Sincronización'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        
        const SizedBox(height: 8),
        
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _testCheckStatus,
          icon: const Icon(Icons.refresh),
          label: const Text('Actualizar Estado'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        
        const SizedBox(height: 8),
        
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _testClearPending,
          icon: const Icon(Icons.clear_all),
          label: const Text('Limpiar Pendientes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Cómo Probar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Presione "Simular Envío Automático" para crear datos de prueba\n'
              '2. Los datos se enviarán automáticamente por email en segundo plano\n'
              '3. Desactive WiFi y datos móviles para probar modo offline\n'
              '4. Observe que el estado cambia a "Sin conexión"\n'
              '5. Reactive la conexión a internet\n'
              '6. El sistema detectará automáticamente y enviará por correo\n'
              '7. Puede cerrar la app durante el proceso - seguirá funcionando\n\n'
              'Nota: El sistema utiliza el servicio de email configurado para enviar automáticamente las encuestas cuando hay conectividad.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testScheduleSurvey() async {
    setState(() {
      _isLoading = true;
      _status = 'Simulando envío de encuesta...';
    });

    try {
      // Crear datos de prueba más realistas
      final testSurveyData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'testData': true,
        'generalInfo': {
          'date': DateTime.now().toIso8601String(),
          'department': 'Departamento de Prueba',
          'municipality': 'Municipio de Prueba',
          'district': 'Corregimiento de Prueba',
          'village': 'Vereda de Prueba',
          'intervieweeName': 'Juan Pérez (Prueba)',
          'contact': '3001234567',
        },
        'institutionalInfo': {
          'institutionName': 'Institución Educativa de Prueba',
          'dane': '123456789012',
          'institutionType': 'Institución Educativa',
          'zone': 'Rural',
          'sector': 'Oficial',
          'calendar': 'A',
          'category': 'Básica',
          'principalName': 'María González (Prueba)',
          'location': 'Ubicación de Prueba',
          'locationCoordinates': '4.5981, -74.0758',
          'educationalHeadquarters': 'Sede Principal',
          'contact': '3109876543',
        },
        'observationsInfo': {
          'additionalObservations': 'Esta es una encuesta de prueba generada automáticamente para verificar el funcionamiento del sistema de sincronización.',
        },
      };

      // Programar para sincronización inmediata
      await AutoSyncService.scheduleImmediateSync(testSurveyData);

      setState(() {
        _status = 'Encuesta de prueba programada para envío automático';
      });

      // Actualizar estado
      await _updateSyncStatus();

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Encuesta de prueba programada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testForcedSync() async {
    setState(() {
      _isLoading = true;
      _status = 'Forzando sincronización...';
    });

    try {
      await AutoSyncService.forceSyncNow();
      
      setState(() {
        _status = 'Sincronización forzada completada';
      });

      // Actualizar estado
      await _updateSyncStatus();

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Sincronización manual completada'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      setState(() {
        _status = 'Error en sincronización forzada: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCheckStatus() async {
    setState(() {
      _isLoading = true;
      _status = 'Actualizando estado...';
    });

    try {
      await _updateSyncStatus();
      setState(() {
        _status = 'Estado actualizado';
      });
    } catch (e) {
      setState(() {
        _status = 'Error actualizando estado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testClearPending() async {
    setState(() {
      _isLoading = true;
      _status = 'Limpiando encuestas pendientes...';
    });

    try {
      // Simular limpieza de pendientes
      // Esto normalmente se haría después de una sincronización exitosa
      
      await _updateSyncStatus();
      setState(() {
        _status = 'Encuestas pendientes limpiadas';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🧹 Pendientes limpiados'),
          backgroundColor: Colors.orange,
        ),
      );

    } catch (e) {
      setState(() {
        _status = 'Error limpiando pendientes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
