import 'package:flutter/foundation.dart';
import 'generalInfo.dart';
import 'institutionalInfo.dart';
import 'coverageInfo.dart';
import 'infrastructureInfo.dart';
import 'observationsInfo.dart';
import 'electricity_info.dart';
import 'appliances_info.dart';
import 'access_route_info.dart';
import 'photographic_record_info.dart';

class SurveyState extends ChangeNotifier {
  GeneralInfo generalInfo = GeneralInfo();
  InstitutionalInfo institutionalInfo = InstitutionalInfo();
  CoverageInfo coverageInfo = CoverageInfo();
  InfrastructureInfo infrastructureInfo = InfrastructureInfo();
  ObservationsInfo observationsInfo = ObservationsInfo();
  ElectricityInfo electricityInfo = ElectricityInfo();
  AppliancesInfo appliancesInfo = AppliancesInfo();
  AccessRouteInfo accessRouteInfo = AccessRouteInfo();
  PhotographicRecordInfo photographicRecordInfo = PhotographicRecordInfo();

  // Constructor por defecto
  SurveyState();

  void updateGeneralInfo(GeneralInfo info) {
    generalInfo = info;
    notifyListeners();
  }

  void updateInstitutionalInfo(InstitutionalInfo info) {
    institutionalInfo = info;
    notifyListeners();
  }

  void updateCoverageInfo(CoverageInfo info) {
    coverageInfo = info;
    notifyListeners();
  }

  void updateInfrastructureInfo(InfrastructureInfo info) {
    infrastructureInfo = info;
    notifyListeners();
  }

  void updateElectricityInfo(ElectricityInfo info) {
    electricityInfo = info;
    notifyListeners();
  }

  void updateAppliancesInfo(AppliancesInfo info) {
    appliancesInfo = info;
    notifyListeners();
  }
  void updateAccessRouteInfo(AccessRouteInfo info) {
    accessRouteInfo = info;
    notifyListeners();
  }

  void updatePhotographicRecordInfo(PhotographicRecordInfo info) {
    photographicRecordInfo = info;
    notifyListeners();
  }

  void updateObservationsInfo(ObservationsInfo info) {
    observationsInfo = info;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
    'generalInfo': generalInfo.toJson(),
    'institutionalInfo': institutionalInfo.toJson(),
    'coverageInfo': coverageInfo.toJson(),
    'infrastructureInfo': infrastructureInfo.toJson(),
    'observationsInfo': observationsInfo.toJson(),
    'electricityInfo': electricityInfo.toJson(),
    'appliancesInfo': appliancesInfo.toJson(),
    'accessRouteInfo': accessRouteInfo.toJson(),
    'photographicRecordInfo': photographicRecordInfo.toJson(),
  };

  // Implementar fromJson para facilitar la conversión desde JSON
  factory SurveyState.fromJson(Map<String, dynamic> json) {
    final state = SurveyState();
    
    if (json['generalInfo'] != null) {
      final generalInfo = json['generalInfo'] as Map<String, dynamic>;
      state.generalInfo.date = generalInfo['date'] != null ? DateTime.parse(generalInfo['date']) : null;
      state.generalInfo.department = generalInfo['department'];
      state.generalInfo.municipality = generalInfo['municipality'];
      state.generalInfo.district = generalInfo['district'];
      state.generalInfo.village = generalInfo['village'];
      state.generalInfo.intervieweeName = generalInfo['intervieweeName'];
      state.generalInfo.contact = generalInfo['contact'];
    }
    
    if (json['institutionalInfo'] != null) {
      final institutionalInfo = json['institutionalInfo'] as Map<String, dynamic>;
      state.institutionalInfo.institutionName = institutionalInfo['institutionName'];
      state.institutionalInfo.dane = institutionalInfo['dane'];
      state.institutionalInfo.institutionType = institutionalInfo['institutionType'];
      state.institutionalInfo.zone = institutionalInfo['zone'];
      state.institutionalInfo.sector = institutionalInfo['sector'];
      state.institutionalInfo.calendar = institutionalInfo['calendar'];
      state.institutionalInfo.category = institutionalInfo['category'];
      state.institutionalInfo.principalName = institutionalInfo['principalName'];
      state.institutionalInfo.location = institutionalInfo['location'];
      state.institutionalInfo.locationCoordinates = institutionalInfo['locationCoordinates'];
      state.institutionalInfo.educationalHeadquarters = institutionalInfo['educationalHeadquarters'];
      state.institutionalInfo.contact = institutionalInfo['contact'];
    }
    
    if (json['observationsInfo'] != null) {
      final observationsInfo = json['observationsInfo'] as Map<String, dynamic>;
      state.observationsInfo.additionalObservations = observationsInfo['additionalObservations'];
    }
    
    if (json['electricityInfo'] != null) {
      final electricityInfo = json['electricityInfo'] as Map<String, dynamic>;
      state.electricityInfo.hasElectricService = electricityInfo['hasElectricService'];
      state.electricityInfo.electricServiceType = electricityInfo['electricServiceType'];
      state.electricityInfo.otherElectricServiceDescription = electricityInfo['otherElectricServiceDescription'];
      state.electricityInfo.interestedInSolarPanels = electricityInfo['interestedInSolarPanels'];
    }
    
    // Agregar más campos según sea necesario
    // Por ahora, esto es suficiente para el envío de email básico
    
    return state;
  }
}