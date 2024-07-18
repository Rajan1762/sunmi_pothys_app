import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_pothys_parking_app/screens/exit_screens/scanner_screen.dart';
import '../../models/parking_data_model.dart';
import '../../services/printing_service/sunmi.dart';
import '../../utils/common_values.dart';
import '../../utils/common_widget.dart';
import '../../utils/constants.dart';
import '../../utils/notification_widgets.dart';
import '../entry_screens/entry_screen.dart';
import 'exit_receipt_widget.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  ScreenshotController controller = ScreenshotController();
  ParkingDataModel parkingData = returnEmptyParkingModel();
  bool _isLoading = false;
  bool isPaymentOptionVisible = false;
  // bool isSaveButtonVisible = false;
  bool isCashSelected = false;
  bool isUpiSelected = false;
  // String duration = "";
  bool reprintStatus = false;
  // String inAmount = '0.0';
  final ScreenshotController _screenController = ScreenshotController();
  final Sunmi _sunmiPrinter = Sunmi();

  @override
  void initState() {
    super.initState();
    _clearDetails();
  }

  _splitString(String barCodeVal) {
    List<String> parts = barCodeVal.split('/');
    parkingData.vehicleno = parts[0];
    parkingData.intime = parts[1];
    parkingData.vehicletype = parts[2];
    parkingData.paymode = parts[3];
    parkingData.counter = parts[4];
    parkingData.userid = parts[5];

    // List<String> dateTimeAndType = parts[1].split('@');
    // parkingData.intime = dateTimeAndType[0];
    // parkingData.vehicletype = dateTimeAndType[1];
    parkingData.amount = parkingData.vehicletype == bikeString ? '50.0' : '100.0';
    parkingData.indate = convertDateTimeToDateFormat(DateTime.parse(parkingData.intime!));
  }

  // _splitString(String barCodeVal) {
  //   List<String> parts = barCodeVal.split('/');
  //   parkingData.vehicleno = parts[0];
  //   List<String> dateTimeAndType = parts[1].split('@');
  //   parkingData.intime = dateTimeAndType[0];
  //   parkingData.vehicletype = dateTimeAndType[1];
  //   parkingData.amount = parkingData.vehicletype == bikeString ? '50.0' : '100.0';
  //   parkingData.indate = convertDateTimeToDateFormat(DateTime.parse(parkingData.intime!));
  // }

  _tariffCalculation() {
    Duration difference =
        DateTime.now().difference(DateTime.parse(parkingData.intime ?? ''));
    print('Time difference:');
    print('Hours: ${difference.inHours}');
    print('Minutes: ${difference.inMinutes % 60}');
    print('Seconds: ${difference.inSeconds % 60}');
    print('Milliseconds: ${difference.inMilliseconds % 1000}');
    print('Microseconds: ${difference.inMicroseconds % 1000}');

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(difference.inHours);
    String minutes = twoDigits(difference.inMinutes.remainder(60));
    String seconds = twoDigits(difference.inSeconds.remainder(60));
    parkingData.duration = "$hours:$minutes:$seconds";

    if (parkingData.vehicletype == bikeString) {
      if (difference.inHours < 3 ||
          (difference.inHours == 3 &&
              difference.inMinutes % 60 == 0 &&
              difference.inSeconds % 60 == 0)) {
        parkingData.outamount = bikeBaseAmount.toString();
      } else {
        int additionalHours = difference.inMinutes > 180 ||
                (difference.inMinutes == 180 && difference.inSeconds > 0)
            ? ((difference.inMinutes - 180) / 60).ceil()
            : 0;
        parkingData.outamount = '${bikeBaseAmount + (additionalHours * bikeAdditionalHourAmount)}';
      }
      parkingData.outamount = double.parse(parkingData.outamount ?? '0') <= bikeBaseAmount
              ? '0.0'
              : parkingData.outamount ?? '0';
    } else {
      if (difference.inHours < 3 ||
          (difference.inHours == 3 &&
              difference.inMinutes % 60 == 0 &&
              difference.inSeconds % 60 == 0)) {
        parkingData.outamount = carBaseAmount.toString();
      } else {
        int additionalHours = difference.inMinutes > 180 ||
                (difference.inMinutes == 180 && difference.inSeconds > 0)
            ? ((difference.inMinutes - 180) / 60).ceil()
            : 0;
        parkingData.outamount = '${carBaseAmount + (additionalHours * carAdditionalHourAmount)}';
      }
      parkingData.outamount = double.parse(parkingData.outamount ?? '0') <= carBaseAmount
              ? '0.0'
              : parkingData.outamount ?? '0';
    }
    print('amount = ${parkingData.outamount}');
  }

  Future<void> _scanQRCode(BuildContext context) async {
    print('object');
    setState(() => _isLoading = true);
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ScannerScreen()));
    print('returned Scanned Value = ${scannedValue.toString()}');
    _splitString(scannedValue.toString());
    // try {
    //   ParkingDataModel? parkingDbData = await dbHelper
    //       ?.retrieveParkingDataByVehicleNo(parkingData.vehicleno ?? '');
    //   if (parkingDbData != null) {
    //     parkingData = parkingDbData;
    //   }
    // } catch (e) {
    //   print('getVehicleDetail Error occurred e = $e');
    //   if (context.mounted) {
    //     showCustomAlertDialog(
    //         context: context, title: 'Error!', message: e.toString());
    //   }
    // }
    if (parkingData.vehicleno != null) {
      _tariffCalculation();
    }else{
      if (context.mounted) {
        showCustomAlertDialog(
            context: context, title: 'Error!', message: 'Error Occurred while scanning data. Please try again');
      }
    }
    setState(() => _isLoading = false);
  }

  void _updateAndSaveData(BuildContext context) async {
    if (parkingData.vehicleno == null || parkingData.vehicleno == '') {
      showCustomAlertDialog(
          context: context,
          title: 'Cannot Save',
          message: 'Incorrect Vehicle Details');
    } else {
      setState(() => _isLoading = true);
      try {
        print('gdfdf');
        parkingData.outdate = convertDateTimeToDateFormat(DateTime.now());
        parkingData.outtime = '${DateTime.now()}';
        parkingData.outuserid = loginUserName;
        parkingData.outcounter = deviceSerialNo;
        await dbHelper?.insertData(parkingData);
        //TODO
        // await dbHelper?.updateDog(parkingData);
        if(parkingData.outamount != null && parkingData.outamount != '' && double.parse(parkingData.outamount ?? '0.0') > 1 && context.mounted)
          {
            showCustomAlertDialog(context: context,title: 'Success',message: 'Vehicle details saved successfully');
            printEntryReceipt(context);
          }
        _clearDetails();
      } catch (e) {
        print('_updateAndSaveData Error occurred e = $e');
        if (context.mounted) {
          showCustomAlertDialog(
              context: context, title: 'Error!', message: e.toString());
        }
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> printEntryReceipt(BuildContext context) async {
    await sendDataToSDK(context,reprintStatus,parkingData);
    if (context.mounted) {
      showAlertDialogWithCancel(
          context: context,
          title: 'Second Copy ?',
          message: 'Press "OK" to print second copy.',
          onPressedFun: sendDataToSDK,
          parkingDataModel: parkingData);
    }
  }

  Future<void> sendDataToSDK(context,bool status,ParkingDataModel? parkingDataModel1) async {
    reprintStatus = status;
    parkingData = parkingDataModel1!;
    final bytes = await controller.captureFromWidget(
        ExitReceiptWidget(
            parkingData: parkingData), //BillWidget(),
        pixelRatio: 2.0,
        context: context);
    img.Image? baseSizeImage = img.decodeImage(bytes);
    img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
    Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
    await _sunmiPrinter.dummyPrint(img: resizedUint8List);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                height: 80,
                width: 80,
                child: Image(image: AssetImage('assets/app-logo.png'))),
        Text(
              'Exit Page',
              style: appBarTextStyle()),
            const SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     _vehicleTextFieldsMethod(
            //       type: VehicleTextEnum.type1,
            //       keyType: TextInputType.text,
            //       onChanged: (v) {
            //         _t1Text.clear();
            //         _t1Text.write(v ?? "");
            //         if (_t1Text.length == 2) {
            //           FocusScope.of(context).nextFocus();
            //         }
            //       },
            //     ),
            //     const HyphenSizedBox(),
            //     _vehicleTextFieldsMethod(
            //       type: VehicleTextEnum.type2,
            //       keyType: TextInputType.number,
            //       tFocusNode: _t2FocusNode,
            //       onChanged: (v) {
            //         _t2Text.clear();
            //         _t2Text.write(v ?? "");
            //         if (_t2Text.length == 2) {
            //           FocusScope.of(context).nextFocus();
            //         }
            //       },
            //     ),
            //     const HyphenSizedBox(),
            //     _vehicleTextFieldsMethod(
            //       type: VehicleTextEnum.type3,
            //       keyType: TextInputType.text,
            //       onChanged: (v) {
            //         _t3Text.clear();
            //         _t3Text.write(v ?? "");
            //         if (_t3Text.length == 2) {
            //           FocusScope.of(context).nextFocus();
            //         }
            //         if (_t3Text.isEmpty) {
            //           FocusScope.of(context).previousFocus();
            //         }
            //       },
            //     ),
            //     const HyphenSizedBox(),
            //     _vehicleTextFieldsMethod(
            //       type: VehicleTextEnum.type4,
            //       keyType: TextInputType.number,
            //       tFocusNode: _t4FocusNode,
            //       fieldWidth: 80,
            //       textLimit: 4,
            //       onChanged: (v) {
            //         _t4Text.clear();
            //         _t4Text.write(v ?? "");
            //         if (_t4Text.isEmpty) {
            //           FocusScope.of(context).previousFocus();
            //         }
            //       },
            //       onSubmitted: (value) async {
            //         vehicleNo = '$_t1Text$_t2Text$_t3Text$_t4Text';
            //         // _vehicleNoFocusNode.unfocus();
            //         setState(() {
            //           _isLoading = true;
            //         });
            //         String s = await getVehicleDetail(vehicleNo);
            //         if (s != '') {
            //           if (context.mounted) {
            //             showSnackBar(context: context, message: s);
            //           }
            //         }
            //       },
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            // SizedBox(
            //   height: 800,
            //   width: 200,
            //   child: AiBarcodeScanner(
            //     onDispose: () {
            //       /// This is called when the barcode scanner is disposed.
            //       /// You can write your own logic here.
            //       debugPrint("Barcode scanner disposed!");
            //     },
            //     hideGalleryButton: false,
            //     controller: _scannerController,
            //     onDetect: (BarcodeCapture capture) {
            //       /// The row string scanned barcode value
            //       final String? scannedValue =
            //           capture.barcodes.first.rawValue;
            //       debugPrint("Barcode scanned: $scannedValue");
            //
            //       /// The `Uint8List` image is only available if `returnImage` is set to `true`.
            //       final Uint8List? image = capture.image;
            //       debugPrint("Barcode image: $image");
            //
            //       /// row data of the barcode
            //       final Object? raw = capture.raw;
            //       debugPrint("Barcode raw: $raw");
            //
            //       /// List of scanned barcodes if any
            //       final List<Barcode> barcodes = capture.barcodes;
            //       debugPrint("Barcode list: $barcodes");
            //       _scannerController.stop();
            //     },
            //     // validator: (value) {
            //     //   if (value.barcodes.isEmpty) {
            //     //     return false;
            //     //   }
            //     //   if (!(value.barcodes.first.rawValue
            //     //       ?.contains('flutter.dev') ??
            //     //       false)) {
            //     //     return false;
            //     //   }
            //     //   return true;
            //     // },
            //   ),
            // ),
            SizedBox(
              width: 100,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  _scanQRCode(context);
                },
                child: const Center(
                    child: Icon(
                  Icons.qr_code,
                  size: 30,
                )),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Container(
                  width: 120,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'V. Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Text(
                  ': ${parkingData.vehicletype ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Container(
                  width: 120,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Duration',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Text(
                  ': ${parkingData.duration}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Container(
                  width: 120,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Entry Amt.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Text(
                  ': ${double.parse(parkingData.amount ?? '0.0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Container(
                  width: 120,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Exit Amt.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      backgroundColor: Colors.yellow,
                    ),
                  ),
                ),
                Text(
                  ': ${(parkingData.outamount == null || parkingData.outamount == '') ? '0.0' : double.parse(parkingData.outamount ?? '0.0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            parkingData.outamount == null ||
                    parkingData.outamount == '' ||
                    double.parse(parkingData.outamount ?? '0.0') < 1
                ? const SizedBox()
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade700, width: 2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 12),
                    child: Row(
                      children: [
                        CashCardWidget(
                          cashStatus: isCashSelected,
                          iconData: Icons.currency_rupee_sharp,
                          title: 'Cash',
                          onPressed: () {
                            parkingData.outpaymode = cashString;
                            setState(() {
                              isCashSelected = true;
                              isUpiSelected = false;
                            });
                          },
                        ),
                        const SizedBox(width: 10.0),
                        CashCardWidget(
                          cashStatus: isUpiSelected,
                          iconData: Icons.qr_code,
                          title: 'UPI',
                          onPressed: () {
                            parkingData.outpaymode = upiString;
                            setState(() {
                              isCashSelected = false;
                              // _isCardSelected = false;
                              isUpiSelected = true;
                            });
                            showUpiAlertDialog(
                                name: 'Rajan',
                                transactionNote: 'Payment for testing',
                                context: context,
                                amount: double.parse(
                                    parkingData.outamount ?? '0.0'));
                          },
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 30.0),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateAndSaveData(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.green), // Background color
                        foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white), // Font color
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18.0), // Button shape
                          ),
                        ),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5), // Padding
                        ),
                      ),
                      child: const Text("Save",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ),
            const SizedBox(height: 10.0),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        onPressed: _clearDetails,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.red),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0), // Button shape
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                          ),
                        ),
                        child: const Text("Cancel",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                  )
          ],
        ),
      ),
    );
  }

  _clearDetails() {
    _isLoading = true;
    isPaymentOptionVisible = false;
    // isSaveButtonVisible = false;
    isCashSelected = false;
    isUpiSelected = false;
    parkingData.clear();
    parkingData.duration = "";
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> printExitReceipt() async {
  //   // Uint8List qrbytes = await generateQR();
  //
  //   final bytes = await controller.captureFromWidget(
  //       ExitReceiptWidget(parkingData: parkingData),
  //       pixelRatio: 2.0,
  //       //delay: Duration(milliseconds: 3000),
  //       context: context);
  //
  //   var base64Image = base64Encode(bytes);
  //   //TODO
  //   // await EzetapSdk.printBitmap(base64Image);
  // }
  //
  // Future<Uint8List> generateQR() async {
  //   final image = img.Image(width: 150, height: 150);
  //   img.fill(image, color: img.ColorRgb8(255, 255, 255));
  //   barcode_image.drawBarcode(
  //       image, barcode_image.Barcode.qrCode(), parkingData!.vehicleno!,
  //       font: img.arial24);
  //   return img.encodePng(image);
  // }
}
