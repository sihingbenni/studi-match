class Mobility {
  late final bool isVehicleRequired;


  Mobility.fromEAJson(Map<String, dynamic> json) {
    isVehicleRequired = json['isVehicleRequired'];
  }
}
