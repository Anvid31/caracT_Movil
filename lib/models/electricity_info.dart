class ElectricityInfo {
  bool? hasElectricService;
  String? electricServiceType;
  String? otherElectricServiceDescription;
  bool? interestedInSolarPanels;
  ElectricityInfo({
    this.hasElectricService,
    this.electricServiceType,
    this.otherElectricServiceDescription,
    this.interestedInSolarPanels,
  });
  Map<String, dynamic> toJson() => {
    'hasElectricService': hasElectricService,
    'electricServiceType': electricServiceType,
    'otherElectricServiceDescription': otherElectricServiceDescription,
    'interestedInSolarPanels': interestedInSolarPanels,
  };
  factory ElectricityInfo.fromJson(Map<String, dynamic> json) {
    return ElectricityInfo(
      hasElectricService: json['hasElectricService'],
      electricServiceType: json['electricServiceType'],
      otherElectricServiceDescription: json['otherElectricServiceDescription'],
      interestedInSolarPanels: json['interestedInSolarPanels'],
    );
  }

  ElectricityInfo copyWith({
    bool? hasElectricService,
    String? electricServiceType,
    String? otherElectricServiceDescription,
    bool? interestedInSolarPanels,
  }) {
    return ElectricityInfo(
      hasElectricService: hasElectricService ?? this.hasElectricService,
      electricServiceType: electricServiceType ?? this.electricServiceType,
      otherElectricServiceDescription: otherElectricServiceDescription ?? this.otherElectricServiceDescription,
      interestedInSolarPanels: interestedInSolarPanels ?? this.interestedInSolarPanels,
    );
  }
}
