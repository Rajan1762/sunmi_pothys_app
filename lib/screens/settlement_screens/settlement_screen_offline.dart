import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';
import 'package:sunmi_pothys_parking_app/utils/constants.dart';
import 'package:sunmi_pothys_parking_app/utils/notification_widgets.dart';
import '../../models/parking_data_model.dart';
import '../../models/settlement_pg_model.dart';
import '../../services/printing_service/sunmi.dart';
import '../../services/settlement_pg_network_calls.dart';
import '../../utils/common_values.dart';
import '../../utils/common_widget.dart';
import '../report_screen/receipt_widget.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class SettlementScreen extends StatefulWidget {
  const SettlementScreen({super.key});

  @override
  State<SettlementScreen> createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  DateTime selectedDate = DateTime.now();
  String dateSelectedDDMMYYYY = "";
  String dateSelectedYYYYMMDD = "";
  String cASH_Value = "0";
  String cARD_Value = "0";
  String uPI_Value = "0";
  SettlementPgModel? settlementData;
  List<SettlementOverallModel?>? overAllSettlementDataList;
  SettlementPgModel? g1CounterDataList;
  SettlementPgModel? g2CounterDataList;
  SettlementPgModel? g3CounterDataList;
  SettlementPgModel? g4CounterDataList;
  SettlementPgModel? g5CounterDataList;
  SettlementPgModel? g6CounterDataList;
  List<SettlementPgModel> settlementPgModelList = [];
  int totalAmount = 0;
  int totalCarCount = 0;
  int totalBikeCount = 0;
  bool counterCheckValue = false;
  ScreenshotController controller = ScreenshotController();
  final TextEditingController _password = TextEditingController();
  bool _passwordStatus = true;
  bool _isLoading = false;
  final Sunmi _sunmiPrinter = Sunmi();
  int cashBikeCount = 0;
  int cashCarCount = 0;
  int upiBikeCount = 0;
  int upiCarCount = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
      _formatDateString();
      _getDbData(currentDate: '$selectedDate');
      // _getNetworkData();
      // _getDetails();
    }
  }

  _getNetworkData() async {
    print("settlementData before = $settlementData");
    settlementData = await getSettlementPgData(
        dateSelectedYYYYMMDD, counterCheckValue ? "" : deviceSerialNo);
    print("settlementData after = $settlementData");
    if (settlementData != null) {
      totalAmount = int.parse(settlementData?.CASH_Amount ?? '0') +
          int.parse(settlementData?.CARD_Amount ?? '0') +
          int.parse(settlementData?.UPI_Amount ?? '0');
      totalCarCount = int.parse(settlementData?.CASH_CAR_Count ?? '0') +
          int.parse(settlementData?.CARD_CAR_Count ?? '0') +
          int.parse(settlementData?.UPI_CAR_Count ?? '0');
      totalBikeCount = int.parse(settlementData?.CASH_BIKE_Count ?? '0') +
          int.parse(settlementData?.CARD_BIKE_Count ?? '0') +
          int.parse(settlementData?.UPI_BIKE_Count ?? '0');
      cASH_Value = settlementData?.CASH_Amount ?? '0';
      cARD_Value = settlementData?.CARD_Amount ?? '0';
      uPI_Value = settlementData?.UPI_Amount ?? '0';

      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  SettlementPgModel _assignSettlementData(
      {required SettlementOverallModel element}) {
    SettlementPgModel? settlementPgModel = SettlementPgModel();
    if (element.vehicleType == 'BIKE') {
      element.payMode == 'CASH'
          ? settlementPgModel.CASH_BIKE_Count = '${element.count}'
          : element.payMode == 'UPI'
          ? settlementPgModel.UPI_BIKE_Count = '${element.count}'
          : settlementPgModel.CARD_BIKE_Count = '${element.count}';
    } else {
      element.payMode == 'CASH'
          ? settlementPgModel.CASH_CAR_Count = '${element.count}'
          : element.payMode == 'UPI'
          ? settlementPgModel.UPI_CAR_Count = '${element.count}'
          : settlementPgModel.CARD_CAR_Count = '${element.count}';
    }

    element.payMode == 'CASH'
        ? settlementPgModel.CASH_Amount = '${element.amount}'
        : element.payMode == 'UPI'
        ? settlementPgModel.UPI_Amount = '${element.amount}'
        : settlementPgModel.CARD_Amount = '${element.amount}';

    settlementPgModel.totalAmount =
        double.parse(settlementPgModel.CASH_Amount ?? '0') +
            double.parse(settlementPgModel.CARD_Amount ?? '0') +
            double.parse(settlementPgModel.UPI_Amount ?? '0');
    settlementPgModel.totalCarCount =
        int.parse(settlementPgModel.CASH_CAR_Count ?? '0') +
            int.parse(settlementPgModel.CARD_CAR_Count ?? '0') +
            int.parse(settlementPgModel.UPI_CAR_Count ?? '0');
    settlementPgModel.totalBikeCount =
        int.parse(settlementPgModel.CASH_BIKE_Count ?? '0') +
            int.parse(settlementPgModel.CARD_BIKE_Count ?? '0') +
            int.parse(settlementPgModel.UPI_BIKE_Count ?? '0');
    settlementPgModel.counterNumber = element.userid!;
    settlementPgModel.deviceNumber = element.counter!;
    return settlementPgModel;
  }

  _getOverAllData() async {
    overAllSettlementDataList =
    await getAllCounterSettlementPgData(dateSelectedYYYYMMDD);
    if (overAllSettlementDataList != null) {
      List<String> counterList = [];
      overAllSettlementDataList?.forEach((element) {
        if (!counterList.contains(element?.userid) && element?.userid != '1') {
          counterList.add(element!.userid!);
        }
      });

      // List<SettlementPgModel> stPgModel = [];
      settlementPgModelList.clear();
      for (int i = 0; i < counterList.length; i++) {
        List<SettlementPgModel> stSubModel = [];
        overAllSettlementDataList?.forEach((element) {
          if (counterList[i] == element?.userid) {
            stSubModel.add(_assignSettlementData(element: element!));
          }
        });
        SettlementPgModel stModel = SettlementPgModel();
        for (var element in stSubModel) {
          stModel.CASH_BIKE_Count =
          '${int.parse(stModel.CASH_BIKE_Count ?? '0') + int.parse(element.CASH_BIKE_Count ?? '0')}';
          stModel.CARD_BIKE_Count =
          '${int.parse(stModel.CARD_BIKE_Count ?? '0') + int.parse(element.CARD_BIKE_Count ?? '0')}';
          stModel.UPI_BIKE_Count =
          '${int.parse(stModel.UPI_BIKE_Count ?? '0') + int.parse(element.UPI_BIKE_Count ?? '0')}';
          stModel.CASH_CAR_Count =
          '${int.parse(stModel.CASH_CAR_Count ?? '0') + int.parse(element.CASH_CAR_Count ?? '0')}';
          stModel.CARD_CAR_Count =
          '${int.parse(stModel.CARD_CAR_Count ?? '0') + int.parse(element.CARD_CAR_Count ?? '0')}';
          stModel.UPI_CAR_Count =
          '${int.parse(stModel.UPI_CAR_Count ?? '0') + int.parse(element.UPI_CAR_Count ?? '0')}';
          stModel.CASH_Amount =
          '${double.parse(stModel.CASH_Amount ?? '0') + double.parse(element.CASH_Amount ?? '0')}';
          stModel.CARD_Amount =
          '${double.parse(stModel.CARD_Amount ?? '0') + double.parse(element.CARD_Amount ?? '0')}';
          stModel.UPI_Amount =
          '${double.parse(stModel.UPI_Amount ?? '0') + double.parse(element.UPI_Amount ?? '0')}';
          stModel.totalBikeCount += element.totalBikeCount;
          stModel.totalCarCount += element.totalCarCount;
          stModel.totalAmount += element.totalAmount;
          stModel.counterNumber = element.counterNumber;
          stModel.deviceNumber = element.deviceNumber;
        }
        settlementPgModelList.add(stModel);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkUserPassword(String password, BuildContext context) async {
    try {
      return checkUserPassword(password: password);
    } catch (e) {
      if (context.mounted) {
        showCustomAlertDialog(
            context: context, title: "Error Occurred.", message: e.toString());
      }
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _formatDateString();
    _getDbData(currentDate: '${DateTime.now()}');
    // _getNetworkData();
    // _getOverAllData();
  }

  _getDbData({required String currentDate})async{
    List<ParkingDataModel>? parkingVehicleList = await dbHelper?.getVehiclesForCurrentDate(currentDate: currentDate);
   cASH_Value = '0';
   uPI_Value = '0';
   double cashValue = 0.0;
   double upiValue = 0.0;
   cashBikeCount = 0;
   upiBikeCount = 0;
   cashCarCount = 0;
   upiCarCount = 0;

    if(context.mounted)
    {
      parkingVehicleList?.forEach((v){
        if(v.paymode==cashString)
        {
          print('cash = ${double.parse(v.amount ?? '0.0')}');
          cashValue += double.parse(v.amount ?? '0.0');
          if(v.vehicletype==carString)
            {
              cashCarCount += 1;
            }else{
            cashBikeCount += 1;
          }
        }else{
          print('upi = ${double.parse(v.amount ?? '0.0')}');
          upiValue += double.parse(v.amount ?? '0.0');
          if(v.vehicletype==bikeString)
          {
            upiBikeCount += 1;
          }else{
            upiCarCount += 1;
          }
        }
      });


      setState(() {
        cASH_Value = cashValue.toString();
        uPI_Value = upiValue.toString();
      });
    }
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const SizedBox(
                    height: 80,
                    width: 80,
                    child: Image(image: AssetImage('assets/app-logo.png'))),
                Text(
                  'Settlement Page',
                  style: appBarTextStyle(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date : $dateSelectedDDMMYYYY'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  deviceSerialNo,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                        child: SettlementHeaderWidget(
                            title: 'Mode',
                            materialColor: appThemeColor)),
                    Expanded(
                        child: SettlementHeaderWidget(
                            title: 'Amount',
                            materialColor: appThemeColor)),
                    Expanded(
                        child: SettlementHeaderWidget(
                            title: 'Car',
                            materialColor: appThemeColor)),
                    Expanded(
                        child: SettlementHeaderWidget(
                            title: 'Bike',
                            materialColor: appThemeColor)),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        child: SettlementSubWidget(
                            content: 'Cash')),
                    Expanded(
                        child: SettlementSubWidget(
                            content:
                            "\u{20B9}${double.parse(cASH_Value).toInt()}")),
                    Expanded(
                        child: SettlementSubWidget(
                            content:cashCarCount.toString())),
                    Expanded(
                        child: SettlementSubWidget(
                            content:cashBikeCount.toString())),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        child: SettlementSubWidget(
                            content: 'UPI')),
                    Expanded(
                        child: SettlementSubWidget(
                            content:
                            '\u{20B9}${double.parse(uPI_Value).toInt()}')),
                    Expanded(
                        child: SettlementSubWidget(
                            content: upiCarCount.toString())),
                    Expanded(
                        child: SettlementSubWidget(
                            content: upiBikeCount.toString())),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        child: SettlementSubWidget(
                            content: 'Total')),
                    Expanded(
                        child: SettlementSubWidget(
                            content:
                            '\u{20B9}${double.parse(cASH_Value) + double.parse(uPI_Value)}')),
                    Expanded(
                        child: SettlementSubWidget(
                            content:
                            '${cashCarCount + upiBikeCount}')),
                    Expanded(
                        child: SettlementSubWidget(
                            content:
                            '${cashBikeCount + upiBikeCount}')),
                  ],
                ),
                const SizedBox(height: 30),
                _isLoading ? const CircularProgressIndicator() :
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _isLoading = true);
                      _printDetails(
                          allCounterStatus: counterCheckValue,
                          context: context);
                    },
                    child: const Text('Print'),
                  ),
                ),
              ],
            ),
          ],
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

  Future<void> _printDetails(
      {required bool allCounterStatus, required BuildContext context}) async {
      String textToPrint = "--------------------------------"
          "\n*** Pothys Parking App ***"
          "\n[ Daily Settlement Report ]"
          "\nDATE  : $dateSelectedDDMMYYYY"
          "\n--------------------------------";
      final bytes = await controller.captureFromWidget(
          getSettlementReceiptWidget(
           cASH_Value: cASH_Value, uPI_Value: uPI_Value, upiCarCount: upiCarCount, upiBikeCount: upiBikeCount,
            cashCarCount: cashCarCount, cashBikeCount: cashBikeCount, currentDate: textToPrint, context: context,
          ),
          pixelRatio: 2.0,
          context: context);
      // final bytes = await controller.captureFromWidget(
      //     SettlementPgReceiptWidget(
      //       settlementData: settlementData,
      //       currentDate: textToPrint,
      //       totalAmount: totalAmount,
      //       totalBikeCount: totalBikeCount,
      //       totalCarCount: totalCarCount,
      //     ),
      //     pixelRatio: 2.0,
      //     context: context);
      img.Image? baseSizeImage = img.decodeImage(bytes);
      img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
      Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
      await _sunmiPrinter.dummyPrint(img: resizedUint8List);
      setState(() {
        _isLoading = false;
      });
  }
}
//
Widget getSettlementReceiptWidget({required BuildContext context,required String currentDate,required String cASH_Value,required String uPI_Value,required int upiCarCount,required  int upiBikeCount,required int cashCarCount,required int cashBikeCount})
{
  return SizedBox(
    height: 430,
    width: MediaQuery.of(context).size.width,
    child: Material(
      child: Container(
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.fromLTRB(8,0,8,10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all()
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/app-logo.png', width: 100, height: 100),
            const Text(
              'POTHYS PRIVATE LIMITED',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  //height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ), const SizedBox(
              height: 5,
            ),
            Text(
              currentDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  //height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: SettlementHeaderWidget(
                        title: 'Mode',
                        materialColor: appThemeColor)),
                Expanded(
                    child: SettlementHeaderWidget(
                        title: 'Amount',
                        materialColor: appThemeColor)),
                Expanded(
                    child: SettlementHeaderWidget(
                        title: 'Car',
                        materialColor: appThemeColor)),
                Expanded(
                    child: SettlementHeaderWidget(
                        title: 'Bike',
                        materialColor: appThemeColor)),
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: SettlementSubWidget(
                        content: 'Cash')),
                Expanded(
                    child: SettlementSubWidget(
                        content:
                        "\u{20B9}${double.parse(cASH_Value).toInt()}")),
                Expanded(
                    child: SettlementSubWidget(
                        content:cashCarCount.toString())),
                Expanded(
                    child: SettlementSubWidget(
                        content:cashBikeCount.toString())),
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: SettlementSubWidget(
                        content: 'UPI')),
                Expanded(
                    child: SettlementSubWidget(
                        content:
                        '\u{20B9}${double.parse(uPI_Value).toInt()}')),
                Expanded(
                    child: SettlementSubWidget(
                        content: upiCarCount.toString())),
                Expanded(
                    child: SettlementSubWidget(
                        content: upiBikeCount.toString())),
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: SettlementSubWidget(
                        content: 'Total')),
                Expanded(
                    child: SettlementSubWidget(
                        content:
                        '\u{20B9}${double.parse(cASH_Value) + double.parse(uPI_Value)}')),
                Expanded(
                    child: SettlementSubWidget(
                        content:
                        '${cashCarCount + upiCarCount}')),
                Expanded(
                    child: SettlementSubWidget(
                        content:
                        '${cashBikeCount + upiBikeCount}')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
