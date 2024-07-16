class ReportPgModel {
  String? bIKEInCount;
  String? bIKEOutCount;
  String? bIKEPendingCount;
  String? bIKEOpeningCount;
  String? cARInCount;
  String? cAROutCount;
  String? cARPendingCount;
  String? cAROpeningCount;

  ReportPgModel({this.bIKEInCount,
    this.bIKEOutCount,
    this.bIKEPendingCount,
    this.bIKEOpeningCount,
    this.cARInCount,
    this.cAROutCount,
    this.cARPendingCount,
    this.cAROpeningCount});

  factory ReportPgModel.fromJson(Map<String, dynamic> json) => ReportPgModel(
    bIKEInCount : json['BIKE_InCount'],
    bIKEOutCount : json['BIKE_OutCount'],
    bIKEPendingCount : json['BIKE_PendingCount'],
    bIKEOpeningCount : json['BIKE_OpeningCount'],
    cARInCount : json['CAR_InCount'],
    cAROutCount : json['CAR_OutCount'],
    cARPendingCount : json['CAR_PendingCount'],
    cAROpeningCount : json['CAR_OpeningCount']);
}