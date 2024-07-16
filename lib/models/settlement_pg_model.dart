class SettlementPgModel {
  String? CASH_Amount;
  String? CASH_BIKE_Count;
  String? CASH_CAR_Count;
  String? CARD_Amount;
  String? CARD_BIKE_Count;
  String? CARD_CAR_Count;
  String? UPI_Amount;
  String? UPI_BIKE_Count;
  String? UPI_CAR_Count;
  double totalAmount = 0;
  int totalCarCount = 0;
  int totalBikeCount = 0;
  // int bikeTotalCount = 0;
  // int carTotalCount = 0;
  String counterNumber = 'Counter';
  String deviceNumber = '';

  SettlementPgModel(
      {this.CASH_Amount,
      this.CASH_BIKE_Count,
      this.CASH_CAR_Count,
      this.CARD_Amount,
      this.CARD_BIKE_Count,
      this.CARD_CAR_Count,
      this.UPI_Amount,
      this.UPI_BIKE_Count,
      this.UPI_CAR_Count});

  factory SettlementPgModel.fromJson(Map<String, dynamic> json) =>
      SettlementPgModel(
        CASH_Amount: json['CASH_Amount'],
        CASH_BIKE_Count: json['CASH_BIKE_Count'],
        CASH_CAR_Count: json['CASH_CAR_Count'],
        CARD_Amount: json['CARD_Amount'],
        CARD_BIKE_Count: json['CARD_BIKE_Count'],
        CARD_CAR_Count: json['CARD_CAR_Count'],
        UPI_Amount: json['UPI_Amount'],
        UPI_BIKE_Count: json['UPI_BIKE_Count'],
        UPI_CAR_Count: json['UPI_CAR_Count'],
      );
}

class SettlementOverallModel {
  String? payMode;
  String? vehicleType;
  String? userid;
  int? count;
 double? amount;
 String? counter;

  SettlementOverallModel._(
      {this.payMode, this.vehicleType, this.userid, this.count, this.amount,this.counter});

  factory SettlementOverallModel.fromJson(Map<String, dynamic> json) =>
      SettlementOverallModel._(
          payMode: json['paymode'],
          vehicleType: json['vehicletype'],
          userid: json['userid'],
          count: json['Count'],
          amount: json['Amount'],
        counter: json['Counter']
      );
}
