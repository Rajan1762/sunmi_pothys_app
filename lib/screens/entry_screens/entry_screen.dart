import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';
import '../../models/parking_data_model.dart';
import '../../services/printing_service/sunmi.dart';
import '../../utils/common_values.dart';
import '../../utils/common_widget.dart';
import '../../utils/constants.dart';
import '../../utils/notification_widgets.dart';
import 'entry_screen_recipt_widget.dart';
import 'package:image/image.dart' as img;
import 'package:barcode_image/barcode_image.dart' as barcode_image;

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  ParkingDataModel? parkingDataModel = returnEmptyParkingModel();
  final FocusNode _t2FocusNode = FocusNode();
  final TextEditingController _vehicleTextController1 = TextEditingController();
  final TextEditingController _vehicleTextController2 = TextEditingController();
  final TextEditingController _vehicleTextController3 = TextEditingController();
  final TextEditingController _vehicleTextController4 = TextEditingController();
  final StringBuffer _t1Text = StringBuffer();
  final StringBuffer _t2Text = StringBuffer();
  final StringBuffer _t3Text = StringBuffer();
  final StringBuffer _t4Text = StringBuffer();
  bool isBikeSelected = false;
  bool isCarSelected = false;
  bool isCashSelected = false;
  bool isUpiSelected = false;
  String vehicleNo = "";
  String vehicleType = "";
  String paymentMode = "";
  bool reprintStatus = false;
  final ScreenshotController _screenController = ScreenshotController();
  bool _isLoading = false;
  final Sunmi _sunmiPrinter = Sunmi();

  @override
  void initState() {
    _clearDetails();
    super.initState();
  }

  @override
  void dispose() {
    _vehicleTextController1.dispose();
    _vehicleTextController2.dispose();
    _vehicleTextController3.dispose();
    _vehicleTextController4.dispose();
    super.dispose();
  }

  _clearDetails() {
    cancelReprintStatus = false;
    _isLoading = true;
    // _isPaymentRetry = false;
    isBikeSelected = false;
    isCarSelected = false;
    isCashSelected = false;
    isCarSelected = false;
    isUpiSelected = false;
    // parkingDataModel = null;
    vehicleNo = '';
    vehicleType = '';
    paymentMode = '';
    vehicleNo = "TN";
    _vehicleTextController1.clear();
    _vehicleTextController1.text = "TN";
    _vehicleTextController2.clear();
    _vehicleTextController3.clear();
    _vehicleTextController4.clear();
    _t1Text.clear();
    _t2Text.clear();
    _t3Text.clear();
    _t4Text.clear();
    _t1Text.write("TN");
    _t2Text.write("");
    _t3Text.write("");
    _t4Text.write("");
    _t2FocusNode.requestFocus();
    setState(() {
      reprintStatus = false;
      _isLoading = false;
    });
  }

  Future<void> printEntryReceipt(BuildContext context) async {
    await sendDataToSDK(context,reprintStatus, parkingDataModel);
    if (context.mounted) {
      await showAlertDialogWithCancel(
          context: context,
          title: 'Second Copy ?',
          message: 'Press "OK" to print second copy.',
          onPressedFun: sendDataToSDK,
          parkingDataModel: parkingDataModel);
      if(cancelReprintStatus)
        {
          _clearDetails();
        }
    }
  }

  Future<void> sendDataToSDK(BuildContext context,bool status, ParkingDataModel? parkingDataModel1) async {
    reprintStatus = status;
    parkingDataModel = parkingDataModel1;
    Uint8List qrBytes = generateQR();
    final bytes = await _screenController.captureFromWidget(
        getReceiptWidget(
          parkingData: parkingDataModel!,
          qrBytes: qrBytes,
          reprintStatus: reprintStatus,
        ),
        pixelRatio: 2.0,
        context: context);
    // _base64Image = base64Encode(bytes);
    img.Image? baseSizeImage = img.decodeImage(bytes);
    img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
    Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
    await _sunmiPrinter.dummyPrint(img: resizedUint8List);
    if(reprintStatus)
    {
      _clearDetails();
    }
    // _sunmiPrinter.dummyPrint(img: bytes);
    //TODO
    // await EzetapSdk.printBitmap(_base64Image);
  }

  Uint8List generateQR() {
    print('${parkingDataModel!.vehicleno!}/${parkingDataModel!.intime}/${parkingDataModel!.vehicletype}/${parkingDataModel?.paymode}/$deviceSerialNo/$loginUserName');

    final image = img.Image(width: 150, height: 150);
    img.fill(image, color: img.ColorRgb8(255, 255, 255));
    barcode_image.drawBarcode(
        image, barcode_image.Barcode.qrCode(), '${parkingDataModel!.vehicleno!}/${parkingDataModel!.intime}/${parkingDataModel!.vehicletype}/${parkingDataModel?.paymode}/$deviceSerialNo/$loginUserName',
        font: img.arial24);
    return img.encodePng(image);
  }

  // Future<String?> makePayment() async {
  //   var json = {
  //     "amount": parkingDataModel?.amount,
  //     // "amount": '1',
  //     "options": {
  //       "paymentMode": parkingDataModel?.paymode,
  //       "references": {
  //         "reference1": parkingDataModel?.vehicleno,
  //         "additionalReferences": ["addRef_xx1", "addRef_xx2"]
  //       },
  //     },
  //     "customer": {
  //       "name": "BrosOneTech",
  //       "mobileNo": "9940301367",
  //       "email": "Testmail@gmail.com"
  //     }
  //   };
  //   // print('parkingDataModel?.amount = ${parkingDataModel?.amount}\nparkingDataModel?.paymode = ${parkingDataModel?.paymode}\nparkingDataModel?.vehicleno = ${parkingDataModel?.vehicleno}\njson = $json');
  //   // return await EzetapSdk.pay(json);
  // }

  Future<String> _saveDetails({required BuildContext context,required bool printStatus}) async {
    vehicleNo = '$_t1Text$_t2Text$_t3Text$_t4Text'.toUpperCase();
    if (vehicleNo != "" &&
        vehicleNo.isNotEmpty &&
        vehicleNo.length > 7 &&
        vehicleNo.length < 11) {
      if (isBikeSelected || isCarSelected) {
        if (isCashSelected || isUpiSelected) {
          vehicleType = isBikeSelected ? bikeString : carString;
          paymentMode = isCashSelected ? cashString : upiString;
          print('vehicleNo = $vehicleNo');
            allocateInitialData();
            parkingDataModel?.vehicleno = vehicleNo;
            try {
              await dbHelper?.insertData(parkingDataModel!);
              print('inserted successfully');
            } catch (e) {
              print('insertData Error e = $e');
              return e.toString();
            }
            if (context.mounted) {
              showCustomAlertDialog(context: context,title: "Success.",message: "Vehicle Entry Done.\nPayment Received.");
              if(printStatus)
                {
                  await printEntryReceipt(context);
                }
            }
          return kSuccess;
        } else {
          return "Select Payment mode";
        }
      } else {
        return "Select Bike or Car";
      }
    } else {
      return 'Fill all fields';
    }
  }

  void allocateInitialData() {
    parkingDataModel?.intime = '${DateTime.now()}';
    parkingDataModel?.indate = convertDateTimeToDateFormat(DateTime.now());
    parkingDataModel?.amount = isBikeSelected ? '50' : '100';
    parkingDataModel?.vehicletype = vehicleType;
    parkingDataModel?.paymode = paymentMode;
    parkingDataModel?.counter = deviceSerialNo;
    parkingDataModel?.userid = loginUserName;
  }

  // _showUpiAlertDialog({required String name, required String transactionNote}) {
  //   const String upiId = 'd.rajan1762-3@okhdfcbank';
  //   // final String name = 'Rajan';
  //   // final String transactionNote = 'Payment for testing';
  //   final double amount = isBikeSelected ? 50.0 : 100.0;
  //
  //   // Generate UPI QR string
  //   final String upiUrl = 'upi://pay?pa=$upiId&pn=$name&am=$amount&tn=$transactionNote';
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           insetPadding: const EdgeInsets.all(0),
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(5))),
  //           child: SizedBox(
  //             height: 300,
  //             width: 300,
  //             child: Center(
  //               child: QrImageView(
  //                 data: upiUrl,
  //                 version: QrVersions.auto,
  //                 size: 220.0,
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                        width: 80,
                        child: Image(image: AssetImage('assets/app-logo.png'))),
                    Text(
                      'Entry Page',
                      style: appBarTextStyle(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _vehicleTextFieldsMethod(
                      type: VehicleTextEnum.type1,
                      keyType: TextInputType.text,
                      onChanged: (v) {
                        _t1Text.clear();
                        _t1Text.write(v ?? "");
                        if (_t1Text.length == 2) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                    const HyphenSizedBox(),
                    _vehicleTextFieldsMethod(
                      type: VehicleTextEnum.type2,
                      keyType: TextInputType.phone,
                      // tFocusNode: _t2FocusNode,
                      onChanged: (v) {
                        _t2Text.clear();
                        _t2Text.write(v ?? "");
                        if (_t2Text.length == 2) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                    const HyphenSizedBox(),
                    _vehicleTextFieldsMethod(
                      type: VehicleTextEnum.type3,
                      keyType: TextInputType.text,
                      onChanged: (v) {
                        _t3Text.clear();
                        _t3Text.write(v ?? "");
                        if (_t3Text.length == 2) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (_t3Text.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                    const HyphenSizedBox(),
                    _vehicleTextFieldsMethod(
                      type: VehicleTextEnum.type4,
                      keyType: TextInputType.number,
                      fieldWidth: 95,
                      textLimit: 4,
                      onChanged: (v) {
                        _t4Text.clear();
                        _t4Text.write(v ?? "");
                        // if (_t4Text.length == 4) {
                        //   FocusScope.of(context).nextFocus();
                        // }
                        if (_t4Text.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  decoration: BoxDecoration(
                    color: appThemeColorShade100,
                    // color: Colors.grey.shade200,
                    border: Border.all(color: appThemeColor, width: 2),
                    // border: Border.all(color: Colors.grey.shade700, width: 2),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12),
                  child: Row(
                    children: [
                      BikeCarWidget(
                        onPressed: () {
                          setState(() {
                            isBikeSelected = true;
                            isCarSelected = false;
                          });
                        },
                        bikeSelected: isBikeSelected,
                        iconData: Icons.directions_bike,
                        title: bikeString,
                      ),
                      const SizedBox(width: 10.0),
                      BikeCarWidget(
                        onPressed: () {
                          setState(() {
                            isBikeSelected = false;
                            isCarSelected = true;
                          });
                        },
                        bikeSelected: isCarSelected,
                        iconData: Icons.directions_car,
                        title: carString,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: appThemeColorShade100,
                    // color: Colors.grey.shade200,
                    border: Border.all(color: appThemeColor, width: 2),
                    // border: Border.all(color: Colors.grey.shade700, width: 2),
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
                          setState(() {
                            isCashSelected = false;
                            // _isCardSelected = false;
                            isUpiSelected = true;
                          });
                          showUpiAlertDialog(
                              name: 'Rajan',
                              transactionNote: 'Payment for testing', context: context, amount: isBikeSelected ? 50.0 : 100.0);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35.0),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SaveAndPrintButtonWidget(
                            title: 'Save',
                            onTap: () async {
                              print('object');
                              setState(() {
                                reprintStatus = false;
                                _isLoading = true;
                              });
                              String s = await _saveDetails(context: context, printStatus: false);
                              if (context.mounted) {
                                if (s != kSuccess) {
                                  showSnackBar(context: context, message: s);
                                }
                                _clearDetails();
                              }
                            },
                          ),
                          const SizedBox(width: 15),
                          SaveAndPrintButtonWidget(
                            title: 'Save & Print',
                            onTap: () async {
                              setState(() {
                                reprintStatus = false;
                                _isLoading = true;
                              });
                              String s = await _saveDetails(context: context, printStatus: true);
                              if (context.mounted) {
                                if (s != '') {
                                  showSnackBar(context: context, message: s);
                                }
                                // Future.delayed(const Duration(seconds: 2),(){
                                //   if(!reprintStatus)
                                //   {
                                //     _clearDetails();
                                //   }
                                // });
                              }
                            },
                          )
                        ],
                      ),
                const SizedBox(height: 20.0),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _clearDetails,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.red),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              Colors.white),
                          shape: WidgetStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20),
                        ))
              ],
            ),
          ),
        ),
      ),
    ));
  }

  SizedBox _vehicleTextFieldsMethod({
    required VehicleTextEnum type,
    required Function(String?) onChanged,
    FocusNode? tFocusNode,
    required TextInputType keyType,
    double? fieldWidth,
    int? textLimit,
  }) {
    return SizedBox(
      height: 60,
      width: fieldWidth ?? 52,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: keyType,
        controller: type == VehicleTextEnum.type1
            ? _vehicleTextController1
            : type == VehicleTextEnum.type2
                ? _vehicleTextController2
                : type == VehicleTextEnum.type3
                    ? _vehicleTextController3
                    : _vehicleTextController4,
        focusNode: tFocusNode,
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: onChanged,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          LengthLimitingTextInputFormatter(textLimit ?? 2),
        ],
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2,color: appThemeColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 3, color: appThemeColor)),
        ),
      ),
    );
  }
}

class SaveAndPrintButtonWidget extends StatelessWidget {
  final String title;
  final Function() onTap;

  const SaveAndPrintButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(title == 'Save' ? Colors.green : Colors.orange),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        ),
        child: Text(title, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

// class ObjectErrorClass{
//   ParkingDataModel? parkingDataModel;
//   String? message;
//   static ObjectErrorClass? obj;
//   ObjectErrorClass._({this.parkingDataModel, this.message});
//   factory ObjectErrorClass.singleton({ParkingDataModel? parkingDataModel, String? message}) {
//     obj ??= ObjectErrorClass._(parkingDataModel: parkingDataModel, message: message);
//     return obj!;
//   }
// }

class CashCardWidget extends StatelessWidget {
  final bool cashStatus;
  final IconData iconData;
  final String title;
  final Function() onPressed;

  const CashCardWidget({
    super.key,
    required this.cashStatus,
    required this.iconData,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 3,
          foregroundColor: cashStatus ? Colors.white : appThemeColor,
          backgroundColor: cashStatus ? appThemeColor : Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          fixedSize: const Size.fromHeight(65.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 30,
            ),
            Text(title, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class BikeCarWidget extends StatelessWidget {
  final bool bikeSelected;
  final Function() onPressed;
  final IconData iconData;
  final String title;

  const BikeCarWidget({
    super.key,
    required this.bikeSelected,
    required this.onPressed,
    required this.iconData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 2,
            foregroundColor: bikeSelected ? Colors.white : appThemeColor,
            backgroundColor: bikeSelected ? appThemeColor : Colors.white,
            fixedSize: const Size.fromHeight(62.0),
          ),
          icon: Icon(iconData, size: 32),
          label: Text(title, style: const TextStyle(fontSize: 20))),
    );
  }
}
