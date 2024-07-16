// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:sunmi_pothys_parking_app/screens/report_screen/receipt_widget.dart';
// import '../../models/report_pg_model.dart';
// import '../../services/printing_service/sunmi.dart';
// import '../../services/report_pg_network_calls.dart';
// import '../../utils/common_values.dart';
// import '../../utils/common_widget.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;
//
// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});
//
//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }
//
// class _ReportScreenState extends State<ReportScreen> {
//   DateTime selectedDate = DateTime.now();
//   String dateSelectedDDMMYYYY = "";
//   String dateSelectedYYYYMMDD = "";
//   String bikeOpeningCount = "0";
//   String carOpeningCount = "0";
//   String bikePendingCount = "0";
//   String carPendingCount = "0";
//   String bikeInCount = "0";
//   String carInCount = "0";
//   String bikeOutCount = "0";
//   String carOutCount = "0";
//   ReportPgModel? reportPgModelData;
//   bool counterCheckValue = false;
//   int totalIn = 0;
//   int totalOut = 0;
//   int totalPending = 0;
//   int openingVehicleCount = 0;
//   ScreenshotController controller = ScreenshotController();
//   final Sunmi _sunmiPrinter = Sunmi();
//
//   @override
//   void initState() {
//     super.initState();
//     _formatDateString();
//     _getNetworkData();
//     // _getDetails();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           '[ Report Page ]',
//           style: TextStyle(backgroundColor: Colors.green, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () => _selectDate(context),
//                 child: Text('Select Date : $dateSelectedDDMMYYYY'),
//               ),
//               const SizedBox(height: 5.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "All Counter",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   Checkbox(
//                     // tristate: true,
//                     value: counterCheckValue,
//                     onChanged: (bool? value) {
//                       print("counterCheckValue value = $value");
//                       setState(() {
//                         counterCheckValue = value ?? false;
//                       });
//                       _getNetworkData();
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               const Row(
//                 children: [
//                   Expanded(
//                       child: SettlementHeaderWidget(
//                           title: 'Type', materialColor: Colors.green)),
//                   Expanded(
//                       child: SettlementHeaderWidget(
//                           title: 'In', materialColor: Colors.green)),
//                   Expanded(
//                       child: SettlementHeaderWidget(
//                           title: 'Out', materialColor: Colors.green)),
//                   Expanded(
//                       child: SettlementHeaderWidget(
//                           title: 'Pending', materialColor: Colors.green)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(child: SettlementSubWidget(content: 'Opening')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '$openingVehicleCount'
//                               : '0')),
//                   const Expanded(child: SettlementSubWidget(content: '0')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '$openingVehicleCount'
//                               : '0')),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(child: SettlementSubWidget(content: 'Bike')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '${reportPgModelData?.bIKEInCount ?? 0}'
//                               : '0')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '${reportPgModelData?.bIKEOutCount ?? 0}'
//                               : '0')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '${reportPgModelData?.bIKEPendingCount ?? 0}'
//                               : '0')),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(child: SettlementSubWidget(content: 'Car')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '${reportPgModelData?.cARInCount ?? 0}'
//                               : '0')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '${reportPgModelData?.cAROutCount ?? 0}'
//                               : '0')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: reportPgModelData != null
//                               ? '${reportPgModelData?.cARPendingCount ?? 0}'
//                               : '0')),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(child: SettlementSubWidget(content: 'Total')),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: "$totalIn")),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: "$totalOut")),
//                   Expanded(
//                       child: SettlementSubWidget(
//                           content: "$totalPending")),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: 120,
//                 child: ElevatedButton(
//                   onPressed: _printDetails,
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.green,
//                   ),
//                   child: const Text('Print'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _formatDateString() {
//     setState(() {
//       dateSelectedYYYYMMDD =
//       "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
//       dateSelectedDDMMYYYY =
//       "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(4, '0')}";
//     });
//   }
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
//     print("settlementData before = $reportPgModelData");
//     reportPgModelData = await getReportPgData(dateSelectedYYYYMMDD,
//         counterCheckValue ? "" : deviceSerialNo);
//     print("settlementData after = $reportPgModelData");
//     if (reportPgModelData != null&&context.mounted){
//       setState(() {
//         openingVehicleCount =
//             int.parse(reportPgModelData?.bIKEOpeningCount ?? '0') +
//                 int.parse(reportPgModelData?.cAROpeningCount ?? '0');
//
//         totalIn = int.parse("$openingVehicleCount") +
//             int.parse(reportPgModelData?.bIKEInCount ?? '0') +
//             int.parse(reportPgModelData?.cARInCount ?? '0');
//
//         totalOut = int.parse(reportPgModelData?.bIKEOutCount ?? '0') +
//             int.parse(reportPgModelData?.cAROutCount ?? '0');
//
//         totalPending = int.parse("$openingVehicleCount") +
//             int.parse(reportPgModelData?.bIKEPendingCount ?? '0') +
//             int.parse(reportPgModelData?.cARPendingCount ?? '0');
//
//         bikeOpeningCount = reportPgModelData?.bIKEOpeningCount ?? '0';
//         carOpeningCount = reportPgModelData?.cAROpeningCount ?? '0';
//         bikeInCount = reportPgModelData?.bIKEInCount ?? '0';
//         carInCount = reportPgModelData?.cARInCount ?? '0';
//         bikeOutCount = reportPgModelData?.bIKEOutCount ?? '0';
//         carOutCount = reportPgModelData?.cAROutCount ?? '0';
//         bikePendingCount = reportPgModelData?.bIKEPendingCount ?? '0';
//         carPendingCount = reportPgModelData?.cARPendingCount ?? '0';
//       });
//     }
//   }
//
//   Future<void> _printDetails() async {
//     String textToPrint =
//         "\n--------------------------------"
//         "\n   *** Pothys Parking App ***"
//         "\n\n    [ Daily IN/OUT Report ]"
//         "\n\n   DATE  : $dateSelectedDDMMYYYY"
//         "\n--------------------------------";
//     final bytes = await controller.captureFromWidget(
//         ReportPgReceiptWidget(
//             reportPgModelData: reportPgModelData,
//             openingVehicleCount: openingVehicleCount,
//             totalIn: totalIn,totalOut: totalOut,totalPending: totalPending,
//             currentDate: textToPrint),
//         pixelRatio: 2.0,
//         context: context);
//     // _base64Image = base64Encode(bytes);
//     img.Image? baseSizeImage = img.decodeImage(bytes);
//     img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
//     Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
//     _sunmiPrinter.dummyPrint(img: resizedUint8List);
//   }
// }
