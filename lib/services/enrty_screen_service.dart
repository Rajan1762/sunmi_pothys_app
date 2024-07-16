import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parking_data_model.dart';
import '../utils/constants.dart';

Future<ObjectErrorClass> getVehicleDetail({required String vehicleNo}) async {
  ObjectErrorClass objectErrorClass = ObjectErrorClass.singleton(parkingDataModel: null,message: null);
  try {
    http.Response response = await http.get(Uri.parse("${apiBaseUrl}GetAlreadyEntryVehicle").replace(queryParameters: {'vehicleNo': vehicleNo}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    ObjectErrorClass.singleton(parkingDataModel: null,message: null);
    if (response.statusCode == 200) {
      print('response.statusCode = ${response.statusCode} getVehicleDetail = ${response.body}');
      objectErrorClass.parkingDataModel = ParkingDataModel.fromJson(json.decode(response.body));
    }else{
      objectErrorClass.message = 'Server unreachable.';
    }
  } catch (e) {
    objectErrorClass.message = 'Exception: $e';
  }
  return objectErrorClass;
}

Future<ObjectErrorClass> saveVehicleDetail(ParkingDataModel parkingDataModel) async {
  Map<String, dynamic> parameters = {
    'vehicletype': parkingDataModel.vehicletype,
    'vehicleno': parkingDataModel.vehicleno,
    'counter': parkingDataModel.counter,
    'userid': parkingDataModel.userid,
    'paymode': parkingDataModel.paymode
  };
  ObjectErrorClass objectErrorClass = ObjectErrorClass.singleton(parkingDataModel: null,message: null);
  try {
    http.Response response = await http.post(Uri.parse('${apiBaseUrl}postEntry'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(parameters));

    print('response.statusCode = ${response.statusCode} saveVehicleDetail = ${response.body}');
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData != null && responseData.isNotEmpty) {
        objectErrorClass.parkingDataModel = ParkingDataModel.fromJson(json.decode(response.body));
      }else{objectErrorClass.message = 'Cannot Save Data.';}
    }else{objectErrorClass.message =  'server unreachable.';}
  } catch (e) {
    print('Exception occurred: $e');
    objectErrorClass.message =  'Exception Occurred = $e';
  }
  return objectErrorClass;
}

Future<ObjectErrorClass> savePaymentDetail(ParkingDataModel parkingDataModel) async {
  Map<String, dynamic> parameters = {
    'vehicleno': parkingDataModel.vehicleno,
    'paymode': parkingDataModel.paymode,
    // 'paystatus': 'Completed',
    'paystatus': parkingDataModel.paystatus,
    'paytxnref': parkingDataModel.paytxnref
  };
  ObjectErrorClass objectErrorClass = ObjectErrorClass.singleton(parkingDataModel: null,message: null);
  try {
    http.Response response = await http.post(Uri.parse("${apiBaseUrl}postEntryPayment"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(parameters));

    print('response.statusCode = ${response.statusCode} savePaymentDetail = ${response.body}');
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData != null && responseData.isNotEmpty) {
        objectErrorClass.parkingDataModel = ParkingDataModel.fromJson(json.decode(response.body));
      } else {
        objectErrorClass.message = "Cannot Save Data.";
      }
    } else {
      objectErrorClass.message = "Server unreachable.";
    }
  } catch (e) {
    objectErrorClass.message = "Exception: $e";
  }
  return objectErrorClass;
}

class ObjectErrorClass{
  ParkingDataModel? parkingDataModel;
  String? message;
  static ObjectErrorClass? obj;
  ObjectErrorClass._({this.parkingDataModel, this.message});
  factory ObjectErrorClass.singleton({ParkingDataModel? parkingDataModel, String? message}) {
    obj ??= ObjectErrorClass._(parkingDataModel: parkingDataModel, message: message);
    return obj!;
  }
}
