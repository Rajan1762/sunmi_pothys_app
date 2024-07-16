import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sunmi_pothys_parking_app/models/parking_data_model.dart';
import 'package:sunmi_pothys_parking_app/utils/common_values.dart';

import '../../../utils/constants.dart';

class VehicleDatabaseHelper {
  static final VehicleDatabaseHelper instance =
      VehicleDatabaseHelper._privateConstructor();
  static Database? _database;

  VehicleDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'kVehicleDBName.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE $kVehicleDBTableName (vehicleno TEXT,transid INTEGER PRIMARY KEY AUTOINCREMENT,vehicletype TEXT,indate TEXT,intime TEXT,createdate TEXT,status TEXT,counter TEXT,userid TEXT,amount TEXT,paymode TEXT,paystatus TEXT,paytxnref TEXT,outdate TEXT,outtime TEXT,duration TEXT,outcounter TEXT,outuserid TEXT,outamount TEXT,totamount TEXT,outpaymode TEXT,outpaystatus TEXT,outpaytxnref TEXT)");
      },
    );
  }

  Future<void> insertData(ParkingDataModel data) async {
    final Database db = await database;
    final s = await db.insert(kVehicleDBTableName, data.toJson());
    print('Insert Status s = $s');
  }

  Future<ParkingDataModel?> retrieveParkingDataByVehicleNo(
      String vehicleNo) async {
    final db = await database;
    List<Map<String, dynamic>> parkingModel = await db.query(
      kVehicleDBTableName,
      limit: 1,
      where: 'vehicleno = ?',
      whereArgs: [vehicleNo],
    );
    print('parkingModel = $parkingModel');
    return parkingModel.isNotEmpty
        ? ParkingDataModel.fromJson(parkingModel.first)
        : null;
  }

  Future<ParkingDataModel?> retrieveCurrentDateVehicles(String date) async {
    final db = await database;
    List<Map<String, dynamic>> parkingModel = await db.query(
      kVehicleDBTableName,
      limit: 1,
      where: 'indate = ?',
      whereArgs: [date],
    );
    print('parkingModel = $parkingModel');
    return parkingModel.isNotEmpty
        ? ParkingDataModel.fromJson(parkingModel.first)
        : null;
  }

  Future<void> updateDog(ParkingDataModel data) async {
    final db = await database;
    final s = await db.update(
      kVehicleDBTableName,
      data.toJson(),
      where: 'vehicleno = ?',
      whereArgs: [data.vehicleno],
    );
    print('Update Status s = $s');
  }

  Future<void> deleteData(ParkingDataModel data) async {
    final Database db = await database;
    await db.delete(
      kVehicleDBTableName,
      where: 'vehicleno = ?',
      whereArgs: [data.vehicleno],
    );
  }

  Future<List<ParkingDataModel>> getVehiclesForCurrentDate({required String currentDate}) async {
    Database db = await database;
    print('currentDate = $currentDate');
    String today = currentDate.toString().substring(0, 10);
    List<ParkingDataModel> pList = [];
    List<Map<String, dynamic>> parkingMapList = await db.query(
      kVehicleDBTableName,
      where: 'SUBSTR(intime, 1, 10) = ? AND userid = ?',
      whereArgs: [today,loginUserName],
    );
    for (var value in parkingMapList) {
      pList.add(ParkingDataModel.fromJson(value));
    }
    return pList;
  }

  Future<List<ParkingDataModel>> getAllData() async {
    final Database db = await database;
    List<Map<String, dynamic>> rawData = await db.query(kVehicleDBTableName);
    List<ParkingDataModel> yourModels =
        rawData.map((map) => ParkingDataModel.fromJson(map)).toList();
    print('getAllData');
    for (var value in yourModels) {
      print('value = ${value.vehicleno}');
    }
    return yourModels;
  }

// Add other methods for updating, deleting data, etc.
}
