import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_pothys_parking_app/models/parking_data_model.dart';
import 'package:sunmi_pothys_parking_app/screens/report_screen/receipt_widget.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';
import 'package:sunmi_pothys_parking_app/utils/constants.dart';
import '../../models/report_pg_model.dart';
import '../../services/printing_service/sunmi.dart';
import '../../services/report_pg_network_calls.dart';
import '../../utils/common_values.dart';
import '../../utils/common_widget.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();
  String dateSelectedDDMMYYYY = "";
  String dateSelectedYYYYMMDD = "";
  String bikeOpeningCount = "0";
  String carOpeningCount = "0";
  String bikePendingCount = "0";
  String carPendingCount = "0";
  String bikeInCount = "0";
  String carInCount = "0";
  String bikeOutCount = "0";
  String carOutCount = "0";
  ReportPgModel? reportPgModelData;
  bool counterCheckValue = false;
  int totalIn = 0;
  int totalOut = 0;
  int totalPending = 0;
  int openingVehicleCount = 0;
  bool _isLoading = false;
  ScreenshotController controller = ScreenshotController();
  final Sunmi _sunmiPrinter = Sunmi();

  int bikeCount = 0;
  int carCount = 0;

  @override
  void initState() {
    super.initState();
    _formatDateString();
    _getDbData(currentDate: '${DateTime.now()}');
    // _getNetworkData();
    // _getDetails();
  }

  _getDbData({required String currentDate})async{
    List<ParkingDataModel>? parkingVehicleList = await dbHelper?.getVehiclesForCurrentDate(currentDate: currentDate);
    carCount = 0;
    bikeCount = 0;
    if(context.mounted)
      {
          parkingVehicleList?.forEach((v){
            if(v.vehicletype==carString)
            {
              carCount += 1;
            }else{
              bikeCount += 1;
            }
        });
          setState(() {});
      }
  }

  _getNetworkData() async {
    print("settlementData before = $reportPgModelData");
    reportPgModelData = await getReportPgData(dateSelectedYYYYMMDD,
        counterCheckValue ? "" : deviceSerialNo);
    print("settlementData after = $reportPgModelData");
    if (reportPgModelData != null&&context.mounted){
      setState(() {
        openingVehicleCount =
            int.parse(reportPgModelData?.bIKEOpeningCount ?? '0') +
                int.parse(reportPgModelData?.cAROpeningCount ?? '0');

        totalIn = int.parse("$openingVehicleCount") +
            int.parse(reportPgModelData?.bIKEInCount ?? '0') +
            int.parse(reportPgModelData?.cARInCount ?? '0');

        totalOut = int.parse(reportPgModelData?.bIKEOutCount ?? '0') +
            int.parse(reportPgModelData?.cAROutCount ?? '0');

        totalPending = int.parse("$openingVehicleCount") +
            int.parse(reportPgModelData?.bIKEPendingCount ?? '0') +
            int.parse(reportPgModelData?.cARPendingCount ?? '0');

        bikeOpeningCount = reportPgModelData?.bIKEOpeningCount ?? '0';
        carOpeningCount = reportPgModelData?.cAROpeningCount ?? '0';
        bikeInCount = reportPgModelData?.bIKEInCount ?? '0';
        carInCount = reportPgModelData?.cARInCount ?? '0';
        bikeOutCount = reportPgModelData?.bIKEOutCount ?? '0';
        carOutCount = reportPgModelData?.cAROutCount ?? '0';
        bikePendingCount = reportPgModelData?.bIKEPendingCount ?? '0';
        carPendingCount = reportPgModelData?.cARPendingCount ?? '0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,20,10,10),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 80,
                      width: 80,
                      child: Image(image: AssetImage('assets/app-logo.png'))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,top: 10),
                    child: Text(
                      'Report Page',
                      style: appBarTextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date : $dateSelectedDDMMYYYY'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                          child: SettlementHeaderWidget(
                              title: 'Type', materialColor: appThemeColor)),
                      Expanded(
                          child: SettlementHeaderWidget(
                              title: 'Count', materialColor: appThemeColor)),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SettlementSubWidget(content: 'Bike')),
                      Expanded(
                          child: SettlementSubWidget(
                              content: bikeCount.toString())),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SettlementSubWidget(content: 'Car')),
                      Expanded(
                          child: SettlementSubWidget(
                              content: carCount.toString())),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SettlementSubWidget(content: 'Total')),
                      Expanded(
                          child: SettlementSubWidget(
                              content: "${bikeCount + carCount}")),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading ? const CircularProgressIndicator() :
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: _printDetails,
                      child: const Text('Print'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _formatDateString() {
    setState(() {
      dateSelectedYYYYMMDD =
      "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      dateSelectedDDMMYYYY =
      "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(4, '0')}";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        print('selectedDate = $selectedDate');
        _formatDateString();
      _getDbData(currentDate: '$selectedDate');
      // _getNetworkData();
      // _getDetails();
    }
  }

  // _getNetworkData() async {
  //   print("settlementData before = $reportPgModelData");
  //   reportPgModelData = await getReportPgData(dateSelectedYYYYMMDD,
  //       counterCheckValue ? "" : deviceSerialNo);
  //   print("settlementData after = $reportPgModelData");
  //   if (reportPgModelData != null&&context.mounted){
  //     setState(() {
  //       openingVehicleCount =
  //           int.parse(reportPgModelData?.bIKEOpeningCount ?? '0') +
  //               int.parse(reportPgModelData?.cAROpeningCount ?? '0');
  //
  //       totalIn = int.parse("$openingVehicleCount") +
  //           int.parse(reportPgModelData?.bIKEInCount ?? '0') +
  //           int.parse(reportPgModelData?.cARInCount ?? '0');
  //
  //       totalOut = int.parse(reportPgModelData?.bIKEOutCount ?? '0') +
  //           int.parse(reportPgModelData?.cAROutCount ?? '0');
  //
  //       totalPending = int.parse("$openingVehicleCount") +
  //           int.parse(reportPgModelData?.bIKEPendingCount ?? '0') +
  //           int.parse(reportPgModelData?.cARPendingCount ?? '0');
  //
  //       bikeOpeningCount = reportPgModelData?.bIKEOpeningCount ?? '0';
  //       carOpeningCount = reportPgModelData?.cAROpeningCount ?? '0';
  //       bikeInCount = reportPgModelData?.bIKEInCount ?? '0';
  //       carInCount = reportPgModelData?.cARInCount ?? '0';
  //       bikeOutCount = reportPgModelData?.bIKEOutCount ?? '0';
  //       carOutCount = reportPgModelData?.cAROutCount ?? '0';
  //       bikePendingCount = reportPgModelData?.bIKEPendingCount ?? '0';
  //       carPendingCount = reportPgModelData?.cARPendingCount ?? '0';
  //     });
  //   }
  // }

  Future<void> _printDetails() async {
    setState(() => _isLoading=true);
    String textToPrint = "\n--------------------------------"
        "\n   *** Pothys Parking App ***"
        "\n\n    [ Daily IN/OUT Report ]"
        "\n\n   DATE  : $dateSelectedDDMMYYYY"
        "\n--------------------------------";
        final bytes = await controller.captureFromWidget(
            getReportPgReceiptWidget(
            currentDate: textToPrint, bikeCount: bikeCount, carCount: carCount),
        pixelRatio: 2.0,
        context: context);
    // _base64Image = base64Encode(bytes);
    img.Image? baseSizeImage = img.decodeImage(bytes);
    img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
    Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
    await _sunmiPrinter.dummyPrint(img: resizedUint8List);
    setState(() => _isLoading=false);
  }
}
