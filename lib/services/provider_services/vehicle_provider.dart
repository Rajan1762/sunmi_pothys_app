import 'package:flutter/material.dart';
import 'package:sunmi_pothys_parking_app/models/parking_data_model.dart';

class VehicleProvider extends ChangeNotifier{
  ParkingDataModel? _parkingDataModel;

  ParkingDataModel? get parkingDataModel => _parkingDataModel;

  set parkingDataModel(ParkingDataModel? value) {
    _parkingDataModel = value;
  }
}
