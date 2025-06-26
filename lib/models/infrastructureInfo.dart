class InfrastructureInfo {
  bool hasSalones;
  bool hasComedor;
  bool hasCocina;
  bool hasSalonReuniones;
  bool hasHabitaciones;
  bool hasBanos;
  bool hasOtros;
  
  // Campos para las cantidades
  int cantidadSalones;
  int cantidadComedor;
  int cantidadCocina;
  int cantidadSalonReuniones;
  int cantidadHabitaciones;
  int cantidadBanos;
  int cantidadOtros;
  
  String proyectosInfraestructura;
  String propiedadPredio;
  
  InfrastructureInfo({
    this.hasSalones = false,
    this.hasComedor = false,
    this.hasCocina = false,
    this.hasSalonReuniones = false,
    this.hasHabitaciones = false,
    this.hasBanos = false,
    this.hasOtros = false,
    this.cantidadSalones = 0,
    this.cantidadComedor = 0,
    this.cantidadCocina = 0,
    this.cantidadSalonReuniones = 0,
    this.cantidadHabitaciones = 0,
    this.cantidadBanos = 0,
    this.cantidadOtros = 0,
    this.proyectosInfraestructura = '',
    this.propiedadPredio = '',
  });

  Map<String, dynamic> toJson() => {
    'hasSalones': hasSalones,
    'hasComedor': hasComedor,
    'hasCocina': hasCocina,
    'hasSalonReuniones': hasSalonReuniones,
    'hasHabitaciones': hasHabitaciones,
    'hasBanos': hasBanos,
    'hasOtros': hasOtros,
    'cantidadSalones': cantidadSalones,
    'cantidadComedor': cantidadComedor,
    'cantidadCocina': cantidadCocina,
    'cantidadSalonReuniones': cantidadSalonReuniones,
    'cantidadHabitaciones': cantidadHabitaciones,
    'cantidadBanos': cantidadBanos,
    'cantidadOtros': cantidadOtros,
    'proyectosInfraestructura': proyectosInfraestructura,
    'propiedadPredio': propiedadPredio,
  };
  factory InfrastructureInfo.fromJson(Map<String, dynamic> json) {
    return InfrastructureInfo(
      hasSalones: json['hasSalones'] ?? false,
      hasComedor: json['hasComedor'] ?? false,
      hasCocina: json['hasCocina'] ?? false,
      hasSalonReuniones: json['hasSalonReuniones'] ?? false,
      hasHabitaciones: json['hasHabitaciones'] ?? false,
      hasBanos: json['hasBanos'] ?? false,
      hasOtros: json['hasOtros'] ?? false,
      cantidadSalones: json['cantidadSalones'] ?? 0,
      cantidadComedor: json['cantidadComedor'] ?? 0,
      cantidadCocina: json['cantidadCocina'] ?? 0,
      cantidadSalonReuniones: json['cantidadSalonReuniones'] ?? 0,
      cantidadHabitaciones: json['cantidadHabitaciones'] ?? 0,
      cantidadBanos: json['cantidadBanos'] ?? 0,
      cantidadOtros: json['cantidadOtros'] ?? 0,
      proyectosInfraestructura: json['proyectosInfraestructura'] ?? '',
      propiedadPredio: json['propiedadPredio'] ?? '',
    );
  }
}
