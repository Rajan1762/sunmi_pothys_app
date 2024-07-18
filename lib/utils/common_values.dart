import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_pothys_parking_app/services/database_services/database_helper_classes/vehicle_db_helper_class.dart';
import 'package:sunmi_pothys_parking_app/utils/constants.dart';
import '../models/parking_data_model.dart';
import 'colors.dart';

String deviceSerialNo = '';
const String appVersion = '2.0';
String loginUserNameString = 'loginUserName';
String loginUserName = '';
enum VehicleTextEnum { type1, type2, type3, type4 }
VehicleDatabaseHelper? dbHelper;
StringBuffer scannedValue = StringBuffer();
bool cancelReprintStatus = false;

ParkingDataModel returnEmptyParkingModel() => ParkingDataModel(vehicletype: null, vehicleno: null, indate: null, intime: null, createdate: null, status: null, counter: deviceSerialNo, userid: loginUserName, amount: null, paymode: null, paystatus: null, paytxnref: null, outdate: null, outtime: null, duration: null, outcounter: null, outuserid: null, outamount: null, totamount: null, outpaymode: null, outpaystatus: null, outpaytxnref: null);
class VehicleValueModel{
  final int baseAmount;
  final int extraAmount;
  VehicleValueModel({required this.baseAmount,required this.extraAmount});
}
VehicleValueModel setVehicleValues({required String vehicleType}){
  return VehicleValueModel(
      baseAmount: vehicleType == carString ? 100 : 50,
      extraAmount: vehicleType == carString ? 50 : 20);
}

String convertDateTimeToDateFormat(DateTime dateTime){
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
}

TextStyle? appBarTextStyle(){
  return TextStyle(
      color: appThemeColor,
      fontSize: 20,
      fontWeight: FontWeight.bold);
}
