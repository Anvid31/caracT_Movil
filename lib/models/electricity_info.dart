class ElectricityInfo {
  bool? hasElectricService;
  String? electricServiceType;
  bool? interestedInSolarPanels;
  ElectricityInfo({
    this.hasElectricService,
    this.electricServiceType,
    this.interestedInSolarPanels,
  });
  Map<String, dynamic> toJson() => {
    'hasElectricService': hasElectricService,
    'electricServiceType': electricServiceType,
    'interestedInSolarPanels': interestedInSolarPanels,
  };
  factory ElectricityInfo.fromJson(Map<String, dynamic> json) {
    return ElectricityInfo(
      hasElectricService: json['hasElectricService'],
      electricServiceType: json['electricServiceType'],
      interestedInSolarPanels: json['interestedInSolarPanels'],
    );
  }

  ElectricityInfo copyWith({
    bool? hasElectricService,
    String? electricServiceType,
    bool? interestedInSolarPanels,
  }) {
    return ElectricityInfo(
      hasElectricService: hasElectricService ?? this.hasElectricService,
      electricServiceType: electricServiceType ?? this.electricServiceType,
      interestedInSolarPanels: interestedInSolarPanels ?? this.interestedInSolarPanels,
    );
  }
}
