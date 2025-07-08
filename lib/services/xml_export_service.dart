// ignore_for_file: avoid_print

import 'dart:io';
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/survey_state.dart';
import '../models/photographic_record_info.dart';

class XmlExportService {
  /// Genera un archivo XML con toda la información del formulario
  static String generateSurveyXml(SurveyState surveyState) {
    final builder = XmlBuilder();
    
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('caracterizacion_sede', nest: () {
      // Metadatos
      builder.element('metadata', nest: () {
        builder.element('fecha_creacion', nest: DateTime.now().toIso8601String());
        builder.element('version_aplicacion', nest: '1.0.0');
        builder.element('dispositivo', nest: Platform.operatingSystem);
      });
      
      // Información General
      builder.element('informacion_general', nest: () {
        final generalInfo = surveyState.generalInfo;
        builder.element('fecha', nest: generalInfo.date?.toIso8601String() ?? '');
        builder.element('departamento', nest: generalInfo.department ?? '');
        builder.element('municipio', nest: generalInfo.municipality ?? '');
        builder.element('corregimiento', nest: generalInfo.district ?? '');
        builder.element('vereda', nest: generalInfo.village ?? '');
        builder.element('nombre_entrevistado', nest: generalInfo.intervieweeName ?? '');
        builder.element('contacto', nest: generalInfo.contact ?? '');
      });
      
      // Información Institucional
      builder.element('informacion_institucional', nest: () {
        final instInfo = surveyState.institutionalInfo;
        builder.element('nombre_institucion', nest: instInfo.institutionName ?? '');
        builder.element('codigo_dane', nest: instInfo.dane ?? '');
        builder.element('tipo_institucion', nest: instInfo.institutionType ?? '');
        builder.element('zona', nest: instInfo.zone ?? '');
        builder.element('sector', nest: instInfo.sector ?? '');
        builder.element('calendario', nest: instInfo.calendar ?? '');
        builder.element('categoria', nest: instInfo.category ?? '');
        builder.element('nombre_rector', nest: instInfo.principalName ?? '');
        builder.element('ubicacion', nest: instInfo.location ?? '');
        builder.element('coordenadas', nest: instInfo.locationCoordinates ?? '');
        builder.element('sede_educativa', nest: instInfo.educationalHeadquarters ?? '');
        builder.element('contacto_institucion', nest: instInfo.contact ?? '');
        builder.element('email', nest: instInfo.email ?? '');
      });
      
      // Información de Cobertura (Estudiantes por nivel)
      builder.element('informacion_cobertura', nest: () {
        final coverageInfo = surveyState.coverageInfo;
        builder.element('preescolar', nest: coverageInfo.preescolar?.toString() ?? '0');
        builder.element('primaria', nest: coverageInfo.primaria?.toString() ?? '0');
        builder.element('secundaria', nest: coverageInfo.segundaria?.toString() ?? '0');
        builder.element('media', nest: coverageInfo.media?.toString() ?? '0');
        builder.element('ciclos', nest: coverageInfo.ciclos?.toString() ?? '0');
        builder.element('sabatina', nest: coverageInfo.sabatina?.toString() ?? '0');
        builder.element('dominical', nest: coverageInfo.dominical?.toString() ?? '0');
        builder.element('total_estudiantes', nest: coverageInfo.totalStudents?.toString() ?? '0');
      });
      
      // Información de Infraestructura
      builder.element('informacion_infraestructura', nest: () {
        final infraInfo = surveyState.infrastructureInfo;
        builder.element('tiene_salones', nest: infraInfo.hasSalones.toString());
        builder.element('tiene_comedor', nest: infraInfo.hasComedor.toString());
        builder.element('tiene_cocina', nest: infraInfo.hasCocina.toString());
        builder.element('tiene_salon_reuniones', nest: infraInfo.hasSalonReuniones.toString());
        builder.element('tiene_habitaciones', nest: infraInfo.hasHabitaciones.toString());
        builder.element('tiene_banos', nest: infraInfo.hasBanos.toString());
        builder.element('tiene_otros', nest: infraInfo.hasOtros.toString());
        builder.element('proyectos_infraestructura', nest: infraInfo.proyectosInfraestructura);
        builder.element('propiedad_predio', nest: infraInfo.propiedadPredio);
      });
      
      // Información Eléctrica
      builder.element('informacion_electrica', nest: () {
        final electricInfo = surveyState.electricityInfo;
        builder.element('servicio_electrico', nest: electricInfo.hasElectricService?.toString() ?? 'false');
        builder.element('interes_paneles_solares', nest: electricInfo.interestedInSolarPanels?.toString() ?? 'false');
      });
      
      // Información de Electrodomésticos
      builder.element('informacion_electrodomesticos', nest: () {
        final appliancesInfo = surveyState.appliancesInfo;
        builder.element('electrodomesticos', nest: () {
          for (var appliance in appliancesInfo.appliances) {
            builder.element('electrodomestico', nest: () {
              builder.element('nombre', nest: appliance.name);
              builder.element('cantidad', nest: appliance.quantity.toString());
              builder.element('en_uso', nest: appliance.isInUse.toString());
            });
          }
        });
        if (appliancesInfo.otherAppliances != null && appliancesInfo.otherAppliances!.isNotEmpty) {
          builder.element('otros_electrodomesticos', nest: appliancesInfo.otherAppliances!);
        }
      });
      
      // Información de Vías de Acceso
      builder.element('vias_acceso', nest: () {
        final accessInfo = surveyState.accessRouteInfo;
        final accessData = accessInfo.toJson();
        accessData.forEach((key, value) {
          if (value != null) {
            builder.element(key, nest: value.toString());
          }
        });
      });
        // Registro Fotográfico
      builder.element('registro_fotografico', nest: () {
        final photoInfo = surveyState.photographicRecordInfo;
        final photos = _getPhotosList(photoInfo);
        
        builder.element('foto_general', nest: photoInfo.generalPhoto ?? '');
        builder.element('foto_infraestructura', nest: photoInfo.infrastructurePhoto ?? '');
        builder.element('foto_electricidad', nest: photoInfo.electricityPhoto ?? '');
        builder.element('foto_ambiente', nest: photoInfo.environmentPhoto ?? '');
        builder.element('fotos_adicionales', nest: photoInfo.additionalPhotos ?? '');
        builder.element('foto_frente_escuela', nest: photoInfo.frontSchoolPhoto ?? '');
        builder.element('foto_aulas', nest: photoInfo.classroomsPhoto ?? '');
        builder.element('foto_cocina', nest: photoInfo.kitchenPhoto ?? '');
        builder.element('foto_comedor', nest: photoInfo.diningRoomPhoto ?? '');
        builder.element('total_fotos', nest: photos.length.toString());
        
        // Lista detallada de fotos
        builder.element('lista_fotos', nest: () {
          for (int i = 0; i < photos.length; i++) {
            if (photos[i].isNotEmpty) {
              builder.element('foto', nest: () {
                builder.element('numero', nest: (i + 1).toString());
                builder.element('ruta', nest: photos[i]);
                builder.element('nombre_archivo', nest: photos[i].split('/').last);
              });
            }
          }
        });
      });
      
      // Observaciones
      builder.element('observaciones', nest: () {
        final obsInfo = surveyState.observationsInfo;
        builder.element('observaciones_adicionales', nest: obsInfo.additionalObservations ?? '');
      });
    });
    
    return builder.buildDocument().toXmlString(pretty: true);
  }
  
  /// Crea un archivo ZIP con el XML y todas las fotos
  static Future<File?> createSurveyPackage(SurveyState surveyState) async {
    try {
      // Debug: Verificar información fotográfica
      final debugPhotoInfo = surveyState.photographicRecordInfo;
      print('🔍 DEBUG - Estado del registro fotográfico:');
      print('   - generalPhoto: ${debugPhotoInfo.generalPhoto}');
      print('   - infrastructurePhoto: ${debugPhotoInfo.infrastructurePhoto}');
      print('   - electricityPhoto: ${debugPhotoInfo.electricityPhoto}');
      print('   - environmentPhoto: ${debugPhotoInfo.environmentPhoto}');
      print('   - frontSchoolPhoto: ${debugPhotoInfo.frontSchoolPhoto}');
      print('   - classroomsPhoto: ${debugPhotoInfo.classroomsPhoto}');
      print('   - kitchenPhoto: ${debugPhotoInfo.kitchenPhoto}');
      print('   - diningRoomPhoto: ${debugPhotoInfo.diningRoomPhoto}');
      print('   - additionalPhotos: ${debugPhotoInfo.additionalPhotos}');
      
      // Obtener directorio temporal
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final packageDir = Directory('${tempDir.path}/survey_package_$timestamp');
      await packageDir.create(recursive: true);
      
      // Generar XML
      final xmlContent = generateSurveyXml(surveyState);
      final institutionName = surveyState.institutionalInfo.institutionName?.replaceAll(' ', '_').replaceAll(RegExp(r'[^\w\-_]'), '') ?? 'sede';
      final xmlFile = File('${packageDir.path}/caracterizacion_${institutionName}_$timestamp.xml');
      await xmlFile.writeAsString(xmlContent);
      
      // Crear directorio para fotos
      final photosDir = Directory('${packageDir.path}/fotos');
      await photosDir.create();
        // Copiar todas las fotos
      final photoInfo = surveyState.photographicRecordInfo;
      final allPhotos = _getPhotosList(photoInfo);
      
      print('📸 Procesando ${allPhotos.length} fotos para incluir en ZIP');
      
      for (int i = 0; i < allPhotos.length; i++) {
        final photoPath = allPhotos[i];
        if (photoPath.isEmpty) continue;
        
        final photoFile = File(photoPath);
        
        if (await photoFile.exists()) {
          try {
            final fileName = 'foto_${i + 1}_${photoFile.path.split(Platform.pathSeparator).last}';
            final targetFile = File('${photosDir.path}/$fileName');
            await photoFile.copy(targetFile.path);
            print('✅ Foto copiada: $fileName');
          } catch (e) {
            print('❌ Error copiando foto ${photoFile.path}: $e');
          }
        } else {
          print('⚠️ Foto no encontrada: $photoPath');
        }
      }
      
      // Crear archivo ZIP
      final archive = Archive();
      
      // Agregar XML al ZIP
      final xmlBytes = await xmlFile.readAsBytes();
      archive.addFile(ArchiveFile(xmlFile.path.split('/').last, xmlBytes.length, xmlBytes));
      
      // Agregar todas las fotos al ZIP
      final photosInZip = <String>[];
      await for (final entity in photosDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final fileBytes = await entity.readAsBytes();
            final relativePath = 'fotos/${entity.path.split(Platform.pathSeparator).last}';
            archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));
            photosInZip.add(relativePath);
            print('✅ Foto agregada al ZIP: $relativePath');
          } catch (e) {
            print('❌ Error agregando foto al ZIP: ${entity.path} - $e');
          }
        }
      }
      
      print('📦 Total de archivos en ZIP: ${archive.files.length}');
      print('📸 Fotos incluidas en ZIP: ${photosInZip.length}');
      
      // Crear archivo ZIP final
      final zipPath = '${tempDir.path}/caracterizacion_${institutionName}_$timestamp.zip';
      final zipFile = File(zipPath);
      final zipData = ZipEncoder().encode(archive)!;
      await zipFile.writeAsBytes(zipData);
      
      // Información final del ZIP
      print('📦 Archivo ZIP creado: ${zipFile.path}');
      print('📊 Tamaño del archivo: ${getFileSize(zipFile)}');
      print('📁 Archivos incluidos en el ZIP:');
      for (var file in archive.files) {
        print('   - ${file.name} (${file.size} bytes)');
      }
      
      // Limpiar directorio temporal
      await packageDir.delete(recursive: true);
      
      return zipFile;
    } catch (e) {
      print('Error creando paquete de encuesta: $e');
      return null;
    }
  }
    /// Obtiene el tamaño del archivo en formato legible
  static String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  /// Método helper para obtener todas las fotos como lista
  static List<String> _getPhotosList(PhotographicRecordInfo photoInfo) {
    final photos = <String>[];
    
    // Helper para agregar foto si es válida
    void addPhotoIfValid(String? photoPath) {
      if (photoPath != null && photoPath.isNotEmpty && photoPath != 'null') {
        photos.add(photoPath);
      }
    }
    
    addPhotoIfValid(photoInfo.generalPhoto);
    addPhotoIfValid(photoInfo.infrastructurePhoto);
    addPhotoIfValid(photoInfo.electricityPhoto);
    addPhotoIfValid(photoInfo.environmentPhoto);
    addPhotoIfValid(photoInfo.frontSchoolPhoto);
    addPhotoIfValid(photoInfo.classroomsPhoto);
    addPhotoIfValid(photoInfo.kitchenPhoto);
    addPhotoIfValid(photoInfo.diningRoomPhoto);
    
    // Si hay fotos adicionales (podrían ser múltiples separadas por comas)
    if (photoInfo.additionalPhotos != null && 
        photoInfo.additionalPhotos!.isNotEmpty && 
        photoInfo.additionalPhotos != 'null') {
      final additionalList = photoInfo.additionalPhotos!.split(',');
      for (final photo in additionalList) {
        final trimmed = photo.trim();
        if (trimmed.isNotEmpty && trimmed != 'null') {
          photos.add(trimmed);
        }
      }
    }
    
    print('📋 Fotos encontradas en el registro: ${photos.length}');
    for (int i = 0; i < photos.length; i++) {
      print('   ${i + 1}. ${photos[i]}');
    }
    
    return photos;
  }
}
