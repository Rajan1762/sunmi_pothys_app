class ParkingDataModel {
  int? transid;
  String? vehicletype;
  String? vehicleno;
  String? indate;
  String? intime;
  String? createdate;
  String? status;
  String? counter;
  String? userid;
  String? amount;
  String? paymode;
  String? paystatus;
  String? paytxnref;
  String? outdate;
  String? outtime;
  String? duration;
  String? outcounter;
  String? outuserid;
  String? outamount;
  String? totamount;
  String? outpaymode;
  String? outpaystatus;
  String? outpaytxnref;

  ParkingDataModel(
      {this.transid,
      required this.vehicletype,
      required this.vehicleno,
      required this.indate,
      required this.intime,
      required this.createdate,
      required this.status,
      required this.counter,
      required this.userid,
      required this.amount,
      required this.paymode,
      required this.paystatus,
      required this.paytxnref,
      required this.outdate,
      required this.outtime,
      required this.duration,
      required this.outcounter,
      required this.outuserid,
      required this.outamount,
      required this.totamount,
      required this.outpaymode,
      required this.outpaystatus,
      required this.outpaytxnref});

  factory ParkingDataModel.fromJson(Map<String, dynamic> json) =>
      ParkingDataModel(
        // transid: '',
        vehicletype: json['vehicletype'],
        vehicleno: json['vehicleno'],
        indate: json['indate'],
        intime: json['intime'],
        createdate: json['createdate'],
        status: json['status'],
        counter: json['counter'],
        userid: json['userid'],
        amount: json['amount'],
        paymode: json['paymode'],
        paystatus: json['paystatus'],
        paytxnref: json['paytxnref'],
        outdate: json['outdate'],
        outtime: json['outtime'],
        duration: json['duration'],
        outcounter: json['outcounter'],
        outuserid: json['outuserid'],
        outamount: json['outamount'],
        totamount: json['totamount'],
        outpaymode: json['outpaymode'],
        outpaystatus: json['outpaystatus'],
        outpaytxnref: json['outpaytxnref'],
      );

  Map<String, dynamic> toJson() => {
        'transid': transid,
        'vehicletype': vehicletype,
        'vehicleno': vehicleno,
        'indate': indate,
        'intime': intime,
        'createdate': createdate,
        'status': status,
        'counter': counter,
        'userid': userid,
        'amount': amount,
        'paymode': paymode,
        'paystatus': paystatus,
        'paytxnref': paytxnref,
        'outdate': outdate,
        'outtime': outtime,
        'duration': duration,
        'outcounter': outcounter,
        'outuserid': outuserid,
        'outamount': outamount,
        'totamount': totamount,
        'outpaymode': outpaymode,
        'outpaystatus': outpaystatus,
        'outpaytxnref': outpaytxnref,
      };

  void clear() {
    vehicletype = null;
    vehicleno = null;
    indate = null;
    intime = null;
    createdate = null;
    status = null;
    counter = null;
    userid = null;
    amount = null;
    paymode = null;
    paystatus = null;
    paytxnref = null;
    outdate = null;
    outtime = null;
    duration = null;
    outcounter = null;
    outuserid = null;
    outamount = null;
    totamount = null;
    outpaymode = null;
    outpaystatus = null;
    outpaytxnref = null;
  }

  // void clear() {
  //   // transid = "";
  //   vehicletype = "";
  //   vehicleno = "";
  //   indate = "";
  //   intime = "";
  //   createdate = "";
  //   status = "";
  //   counter = "";
  //   userid = "";
  //   amount = "";
  //   paymode = "";
  //   paystatus = "";
  //   paytxnref = "";
  //   outdate = "";
  //   outtime = "";
  //   duration = "";
  //   outcounter = "";
  //   outuserid = "";
  //   outamount = "";
  //   totamount = "";
  //   outpaymode = "";
  //   outpaystatus = "";
  //   outpaytxnref = "";
  // }
}
