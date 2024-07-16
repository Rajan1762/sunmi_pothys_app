// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:sunmi_pothys_parking_app/utils/notification_widgets.dart';
// import '../../models/settlement_pg_model.dart';
// import '../../services/printing_service/sunmi.dart';
// import '../../services/settlement_pg_network_calls.dart';
// import '../../utils/common_values.dart';
// import '../../utils/common_widget.dart';
// import '../report_screen/receipt_widget.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;
//
// class SettlementScreen extends StatefulWidget {
//   const SettlementScreen({super.key});
//
//   @override
//   State<SettlementScreen> createState() => _SettlementScreenState();
// }
//
// class _SettlementScreenState extends State<SettlementScreen> {
//   DateTime selectedDate = DateTime.now();
//   String dateSelectedDDMMYYYY = "";
//   String dateSelectedYYYYMMDD = "";
//   String cASH_Value = "0";
//   String cARD_Value = "0";
//   String uPI_Value = "0";
//   SettlementPgModel? settlementData;
//   List<SettlementOverallModel?>? overAllSettlementDataList;
//   SettlementPgModel? g1CounterDataList;
//   SettlementPgModel? g2CounterDataList;
//   SettlementPgModel? g3CounterDataList;
//   SettlementPgModel? g4CounterDataList;
//   SettlementPgModel? g5CounterDataList;
//   SettlementPgModel? g6CounterDataList;
//   List<SettlementPgModel> settlementPgModelList = [];
//   int totalAmount = 0;
//   int totalCarCount = 0;
//   int totalBikeCount = 0;
//   bool counterCheckValue = false;
//   ScreenshotController controller = ScreenshotController();
//   final TextEditingController _password = TextEditingController();
//   bool _passwordStatus = true;
//   bool _isLoading = false;
//   final Sunmi _sunmiPrinter = Sunmi();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//       _formatDateString();
//       _getNetworkData();
//       // _getDetails();
//     }
//   }
//
//   _getNetworkData() async {
//     print("settlementData before = $settlementData");
//     settlementData = await getSettlementPgData(
//         dateSelectedYYYYMMDD, counterCheckValue ? "" : deviceSerialNo);
//     print("settlementData after = $settlementData");
//     if (settlementData != null) {
//       totalAmount = int.parse(settlementData?.CASH_Amount ?? '0') +
//           int.parse(settlementData?.CARD_Amount ?? '0') +
//           int.parse(settlementData?.UPI_Amount ?? '0');
//       totalCarCount = int.parse(settlementData?.CASH_CAR_Count ?? '0') +
//           int.parse(settlementData?.CARD_CAR_Count ?? '0') +
//           int.parse(settlementData?.UPI_CAR_Count ?? '0');
//       totalBikeCount = int.parse(settlementData?.CASH_BIKE_Count ?? '0') +
//           int.parse(settlementData?.CARD_BIKE_Count ?? '0') +
//           int.parse(settlementData?.UPI_BIKE_Count ?? '0');
//       cASH_Value = settlementData?.CASH_Amount ?? '0';
//       cARD_Value = settlementData?.CARD_Amount ?? '0';
//       uPI_Value = settlementData?.UPI_Amount ?? '0';
//
//       if (context.mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   SettlementPgModel _assignSettlementData(
//       {required SettlementOverallModel element}) {
//     SettlementPgModel? settlementPgModel = SettlementPgModel();
//     if (element.vehicleType == 'BIKE') {
//       element.payMode == 'CASH'
//           ? settlementPgModel.CASH_BIKE_Count = '${element.count}'
//           : element.payMode == 'UPI'
//               ? settlementPgModel.UPI_BIKE_Count = '${element.count}'
//               : settlementPgModel.CARD_BIKE_Count = '${element.count}';
//     } else {
//       element.payMode == 'CASH'
//           ? settlementPgModel.CASH_CAR_Count = '${element.count}'
//           : element.payMode == 'UPI'
//               ? settlementPgModel.UPI_CAR_Count = '${element.count}'
//               : settlementPgModel.CARD_CAR_Count = '${element.count}';
//     }
//
//     element.payMode == 'CASH'
//         ? settlementPgModel.CASH_Amount = '${element.amount}'
//         : element.payMode == 'UPI'
//             ? settlementPgModel.UPI_Amount = '${element.amount}'
//             : settlementPgModel.CARD_Amount = '${element.amount}';
//
//     settlementPgModel.totalAmount =
//         double.parse(settlementPgModel.CASH_Amount ?? '0') +
//             double.parse(settlementPgModel.CARD_Amount ?? '0') +
//             double.parse(settlementPgModel.UPI_Amount ?? '0');
//     settlementPgModel.totalCarCount =
//         int.parse(settlementPgModel.CASH_CAR_Count ?? '0') +
//             int.parse(settlementPgModel.CARD_CAR_Count ?? '0') +
//             int.parse(settlementPgModel.UPI_CAR_Count ?? '0');
//     settlementPgModel.totalBikeCount =
//         int.parse(settlementPgModel.CASH_BIKE_Count ?? '0') +
//             int.parse(settlementPgModel.CARD_BIKE_Count ?? '0') +
//             int.parse(settlementPgModel.UPI_BIKE_Count ?? '0');
//     settlementPgModel.counterNumber = element.userid!;
//     settlementPgModel.deviceNumber = element.counter!;
//     return settlementPgModel;
//   }
//
//   _getOverAllData() async {
//     overAllSettlementDataList =
//         await getAllCounterSettlementPgData(dateSelectedYYYYMMDD);
//     if (overAllSettlementDataList != null) {
//       List<String> counterList = [];
//       overAllSettlementDataList?.forEach((element) {
//         if (!counterList.contains(element?.userid) && element?.userid != '1') {
//           counterList.add(element!.userid!);
//         }
//       });
//
//       // List<SettlementPgModel> stPgModel = [];
//       settlementPgModelList.clear();
//       for (int i = 0; i < counterList.length; i++) {
//         List<SettlementPgModel> stSubModel = [];
//         overAllSettlementDataList?.forEach((element) {
//           if (counterList[i] == element?.userid) {
//             stSubModel.add(_assignSettlementData(element: element!));
//           }
//         });
//         SettlementPgModel stModel = SettlementPgModel();
//         for (var element in stSubModel) {
//           stModel.CASH_BIKE_Count =
//               '${int.parse(stModel.CASH_BIKE_Count ?? '0') + int.parse(element.CASH_BIKE_Count ?? '0')}';
//           stModel.CARD_BIKE_Count =
//               '${int.parse(stModel.CARD_BIKE_Count ?? '0') + int.parse(element.CARD_BIKE_Count ?? '0')}';
//           stModel.UPI_BIKE_Count =
//               '${int.parse(stModel.UPI_BIKE_Count ?? '0') + int.parse(element.UPI_BIKE_Count ?? '0')}';
//           stModel.CASH_CAR_Count =
//               '${int.parse(stModel.CASH_CAR_Count ?? '0') + int.parse(element.CASH_CAR_Count ?? '0')}';
//           stModel.CARD_CAR_Count =
//               '${int.parse(stModel.CARD_CAR_Count ?? '0') + int.parse(element.CARD_CAR_Count ?? '0')}';
//           stModel.UPI_CAR_Count =
//               '${int.parse(stModel.UPI_CAR_Count ?? '0') + int.parse(element.UPI_CAR_Count ?? '0')}';
//           stModel.CASH_Amount =
//               '${double.parse(stModel.CASH_Amount ?? '0') + double.parse(element.CASH_Amount ?? '0')}';
//           stModel.CARD_Amount =
//               '${double.parse(stModel.CARD_Amount ?? '0') + double.parse(element.CARD_Amount ?? '0')}';
//           stModel.UPI_Amount =
//               '${double.parse(stModel.UPI_Amount ?? '0') + double.parse(element.UPI_Amount ?? '0')}';
//           stModel.totalBikeCount += element.totalBikeCount;
//           stModel.totalCarCount += element.totalCarCount;
//           stModel.totalAmount += element.totalAmount;
//           stModel.counterNumber = element.counterNumber;
//           stModel.deviceNumber = element.deviceNumber;
//         }
//         settlementPgModelList.add(stModel);
//       }
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<bool> _checkUserPassword(String password, BuildContext context) async {
//     try {
//       return checkUserPassword(password: password);
//     } catch (e) {
//       if (context.mounted) {
//         showCustomAlertDialog(
//             context: context, title: "Error Occurred.", message: e.toString());
//       }
//       return false;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _formatDateString();
//     // _getNetworkData();
//     // _getOverAllData();
//   }
//
//   @override
//   void dispose() {
//     _password.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text(
//               '[ Settlement Page ]',
//               style: TextStyle(
//                   backgroundColor: Colors.green,
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "All Counter",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Checkbox(
//                       // tristate: true,
//                       value: counterCheckValue,
//                       onChanged: (bool? value) {
//                         print("counterCheckValue value = $value");
//                         setState(() {
//                           _isLoading = true;
//                           counterCheckValue = value ?? false;
//                         });
//                         if (counterCheckValue) {
//                           _getOverAllData();
//                         } else {
//                           _getNetworkData();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _selectDate(context),
//                   child: Text('Select Date : $dateSelectedDDMMYYYY'),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Expanded(
//                   child: counterCheckValue
//                       ? ListView.builder(
//                           itemCount: settlementPgModelList.length,
//                           itemBuilder: (context, index) {
//                             return Column(
//                               children: [
//                                 Text(
//                                   settlementPgModelList[index].counterNumber,
//                                   style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 const Row(
//                                   children: [
//                                     Expanded(
//                                         child: SettlementHeaderWidget(
//                                             title: 'Mode',
//                                             materialColor: Colors.green)),
//                                     Expanded(
//                                         child: SettlementHeaderWidget(
//                                             title: 'Amount',
//                                             materialColor: Colors.green)),
//                                     Expanded(
//                                         child: SettlementHeaderWidget(
//                                             title: 'Car',
//                                             materialColor: Colors.green)),
//                                     Expanded(
//                                         child: SettlementHeaderWidget(
//                                             title: 'Bike',
//                                             materialColor: Colors.green)),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Expanded(
//                                         child: SettlementSubWidget(
//                                             content: 'Cash')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 "\u{20B9}${double.parse(settlementPgModelList[index].CASH_Amount ?? '0.0').toInt()}")),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 settlementPgModelList[index]
//                                                         .CASH_CAR_Count ??
//                                                     '0')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 settlementPgModelList[index]
//                                                         .CASH_BIKE_Count ??
//                                                     '0')),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Expanded(
//                                         child: SettlementSubWidget(
//                                             content: 'Card')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 '\u{20B9}${double.parse(settlementPgModelList[index].CARD_Amount ?? '0.0').toInt()}')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 settlementPgModelList[index]
//                                                         .CARD_CAR_Count ??
//                                                     '0')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 settlementPgModelList[index]
//                                                         .CARD_BIKE_Count ??
//                                                     '0')),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Expanded(
//                                         child: SettlementSubWidget(
//                                             content: 'UPI')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 '\u{20B9}${double.parse(settlementPgModelList[index].UPI_Amount ?? '0.0').toInt()}')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 settlementPgModelList[index]
//                                                         .UPI_CAR_Count ??
//                                                     '0')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 settlementPgModelList[index]
//                                                         .UPI_BIKE_Count ??
//                                                     '0')),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Expanded(
//                                         child: SettlementSubWidget(
//                                             content: 'Total')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 '\u{20B9}${settlementPgModelList[index].totalAmount.toInt()}')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 '${settlementPgModelList[index].totalCarCount}')),
//                                     Expanded(
//                                         child: SettlementSubWidget(
//                                             content:
//                                                 '${settlementPgModelList[index].totalBikeCount}')),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                               ],
//                             );
//                           })
//                       : ListView(
//                           children: [
//                             Text(
//                               '${settlementData?.counterNumber}',
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w600),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             const Row(
//                               children: [
//                                 Expanded(
//                                     child: SettlementHeaderWidget(
//                                         title: 'Mode',
//                                         materialColor: Colors.green)),
//                                 Expanded(
//                                     child: SettlementHeaderWidget(
//                                         title: 'Amount',
//                                         materialColor: Colors.green)),
//                                 Expanded(
//                                     child: SettlementHeaderWidget(
//                                         title: 'Car',
//                                         materialColor: Colors.green)),
//                                 Expanded(
//                                     child: SettlementHeaderWidget(
//                                         title: 'Bike',
//                                         materialColor: Colors.green)),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Expanded(
//                                     child:
//                                         SettlementSubWidget(content: 'Cash')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             "\u{20B9}${settlementData?.CASH_Amount ?? 0}")),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             settlementData?.CASH_CAR_Count ??
//                                                 '0')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             settlementData?.CASH_BIKE_Count ??
//                                                 '0')),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Expanded(
//                                     child:
//                                         SettlementSubWidget(content: 'Card')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             '\u{20B9}${settlementData?.CARD_Amount ?? 0}')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             settlementData?.CARD_CAR_Count ??
//                                                 '0')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             settlementData?.CARD_BIKE_Count ??
//                                                 '0')),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Expanded(
//                                     child: SettlementSubWidget(content: 'UPI')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             '\u{20B9}${settlementData?.UPI_Amount ?? 0}')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             settlementData?.UPI_CAR_Count ??
//                                                 '0')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             settlementData?.UPI_BIKE_Count ??
//                                                 '0')),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 const Expanded(
//                                     child:
//                                         SettlementSubWidget(content: 'Total')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             '\u{20B9}${settlementData?.totalAmount ?? 0}')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             '${settlementData?.totalCarCount ?? 0}')),
//                                 Expanded(
//                                     child: SettlementSubWidget(
//                                         content:
//                                             '${settlementData?.totalBikeCount ?? 0}')),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                 ),
//                 SizedBox(
//                   width: 120,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _printDetails(
//                           allCounterStatus: counterCheckValue,
//                           context: context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.green,
//                     ),
//                     child: const Text('Print'),
//                   ),
//                 ),
//               ],
//             ),
//             Visibility(
//                 visible: _passwordStatus,
//                 child: Container(
//                   color: Colors.white,
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           TextField(
//                             obscureText: true,
//                             controller: _password,
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               contentPadding:
//                                   EdgeInsets.symmetric(horizontal: 16.0),
//                               labelText: 'Password',
//                               hintText: 'Admin Password',
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 if (_password.value.text != '') {
//                                   setState(() {
//                                     _isLoading = true;
//                                   });
//                                   bool status = await _checkUserPassword(
//                                       _password.value.text, context);
//                                   if (status) {
//                                     _passwordStatus = !_passwordStatus;
//                                     _getNetworkData();
//                                   } else {
//                                     if (context.mounted) {
//                                       showSnackBar(
//                                           context: context,
//                                           message: 'Incorrect Password');
//                                       setState(() {
//                                         _isLoading = false;
//                                       });
//                                     }
//                                   }
//                                 } else {
//                                   showSnackBar(
//                                       context: context,
//                                       message:
//                                           'Password field cannot be Empty');
//                                 }
//                               },
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 5),
//                                 child: Text(
//                                   'Enter',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ))
//                         ],
//                       ),
//                     ),
//                   ),
//                 )),
//             Visibility(
//                 visible: _isLoading,
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child: const Center(
//                       child: Card(
//                           elevation: 5,
//                           color: Colors.white,
//                           child: Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: CircularProgressIndicator(strokeWidth: 6),
//                           )),
//                     ),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   _formatDateString() {
//     setState(() {
//       dateSelectedYYYYMMDD =
//           "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
//       dateSelectedDDMMYYYY =
//           "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(4, '0')}";
//     });
//   }
//
//   Future<void> _printDetails(
//       {required bool allCounterStatus, required BuildContext context}) async {
//     setState(() {
//       _isLoading = true;
//     });
//     if (allCounterStatus) {
//       String textToPrint = "--------------------------------"
//           "\n   *** Pothys Parking App ***"
//           "\n    [ Daily Settlement Report ]"
//           "\n   DATE  : $dateSelectedDDMMYYYY"
//           "\n--------------------------------";
//       for (var element in settlementPgModelList) {
//         if (context.mounted) {
//           final bytes = await controller.captureFromWidget(
//               SettlementPgAllCounterReceiptWidget(
//                 settlementData: element,
//                 currentDate: textToPrint,
//                 totalAmount: element.totalAmount.toInt(),
//                 totalBikeCount: element.totalBikeCount,
//                 totalCarCount: element.totalCarCount,
//               ),
//               pixelRatio: 2.0,
//               context: context);
//           img.Image? baseSizeImage = img.decodeImage(bytes);
//           img.Image resizedImage =
//               img.copyResize(baseSizeImage!, width: 383, height: 750);
//           Uint8List resizedUint8List =
//               Uint8List.fromList(img.encodePng(resizedImage));
//           _sunmiPrinter.dummyPrint(img: resizedUint8List);
//           // var base64Image = base64Encode(bytes);
//           // await EzetapSdk.printBitmap(base64Image);
//         }
//       }
//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//       String textToPrint = "\n--------------------------------"
//           "\n   *** Pothys Parking App ***"
//           "\n\n    [ Daily Settlement Report ]"
//           "\n\n   DATE  : $dateSelectedDDMMYYYY"
//           "\n--------------------------------";
//
//       final bytes = await controller.captureFromWidget(
//           SettlementPgReceiptWidget(
//             settlementData: settlementData,
//             currentDate: textToPrint,
//             totalAmount: totalAmount,
//             totalBikeCount: totalBikeCount,
//             totalCarCount: totalCarCount,
//           ),
//           pixelRatio: 2.0,
//           context: context);
//       img.Image? baseSizeImage = img.decodeImage(bytes);
//       img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
//       Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
//       _sunmiPrinter.dummyPrint(img: resizedUint8List);
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
