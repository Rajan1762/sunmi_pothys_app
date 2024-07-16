import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_image/barcode_image.dart' as barcode_image;
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_pothys_parking_app/models/parking_data_model.dart';
import 'package:sunmi_pothys_parking_app/screens/profile_screens/login_screen.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';
import 'package:sunmi_pothys_parking_app/utils/common_values.dart';
import '../../services/printing_service/sunmi.dart';
import '../../utils/constants.dart';
import '../../utils/notification_widgets.dart';
import '../entry_screens/entry_screen_recipt_widget.dart';
import '../exit_screens/exit_receipt_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ScreenshotController controller = ScreenshotController();
  ParkingDataModel parkingData = returnEmptyParkingModel();
  bool reprintStatus = true;
  final Sunmi _sunmiPrinter = Sunmi();

  @override
  void initState() {
    super.initState();
  }

  // void _showToast(String data) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(data),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     '[ Setting Page ]',
      //     style: TextStyle(backgroundColor: Colors.green, color: Colors.white),
      //   ),
      //   centerTitle: true,
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.asset(
            'assets/app-logo.png',
            width: 100,
            height: 100,
          ), Text(
        'Setting Page',
        style: appBarTextStyle()),
          const SizedBox(height: 10),
          const Text(
            'Pothys Parking App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Counter No : $deviceSerialNo',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: (){_logout(context);},
            child: const Text('Logout'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _testPrint,
            child: const Text('Test : Print'),
          ),
          ElevatedButton(
            onPressed: (){_entryPrint(context);},
            child: const Text('Entry : Print'),
          ),
          ElevatedButton(
            onPressed: (){_ExitPrint(context);},
            child: const Text('Exit : Print'),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Powered by Bro's OneTech",style: TextStyle(color: appThemeColor,fontWeight: FontWeight.bold,fontSize: 16)),
            ],
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(sp_isUserAuthenticated, false);
    prefs.setString(sp_loginUserName, '');
    if(context.mounted)
      {
        showSnackBar(context: context,message: 'Logout Success.');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
  }

  Future<void> _testPrint() async {
    var txtReceipt = "";
    txtReceipt = "\n--------------------";
    txtReceipt = "\n*** TEST PRINT OK ***";
    DateTime now = DateTime.now();
    String DateTimeValue = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";
    txtReceipt += "\n" + DateTimeValue;
    txtReceipt += "\n--------------------";
    await _sunmiPrinter.printText(txtReceipt);
    // String? result = await EzetapSdk.printTextReceipt(txtReceipt);
    // Utils.showAlertDialog(context, "result", result, () {});
    // if (!mounted) return;
    // setState(() {
    //   _result = result;
    // });
  }

  Future<void> _entryPrint(BuildContext context) async {
    parkingData.vehicleno = "TN00XY12345";
    parkingData.vehicletype = "CAR";
    parkingData.indate = "01/01/2024 10:00:00";
    parkingData.amount = "100.00";
    parkingData.paymode = "CASH";
    parkingData.counter = "GATE12345";
    parkingData.userid = "ADMIN";

    Uint8List qrbytes = await generateQR();
    if(context.mounted)
      {
        final bytes = await controller.captureFromWidget(getReceiptWidget(parkingData: parkingData, qrBytes: qrbytes, reprintStatus: reprintStatus),
            pixelRatio: 2.0,
            context: context);
        img.Image? baseSizeImage = img.decodeImage(bytes);
        img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
        Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
        await _sunmiPrinter.dummyPrint(img: resizedUint8List);
        setState(() => reprintStatus = !reprintStatus);
      }
  }

  Future<void> _ExitPrint(BuildContext context) async {
    parkingData.vehicleno = "TN00XY12345";
    parkingData.vehicletype = "CAR";

    parkingData.indate = "01/01/2024 10:00:00";
    parkingData.amount = "100.00";
    parkingData.paymode = "CASH";
    parkingData.counter = "GATE12345";
    parkingData.userid = "ADMIN";

    parkingData.outdate = "01/01/2024 16:00:00";
    parkingData.outamount = "30.00";
    parkingData.outpaymode = "CASH";
    parkingData.outcounter = "GATE54321";
    parkingData.outuserid = "ADMIN";

    // Uint8List qrbytes = await generateQR();
    if(context.mounted)
      {
        final bytes = await controller.captureFromWidget(
            ExitReceiptWidget(
                parkingData: parkingData), //BillWidget(),
            pixelRatio: 2.0,
            //delay: Duration(seconds: 3),
            context: context);

        img.Image? baseSizeImage = img.decodeImage(bytes);
        img.Image resizedImage = img.copyResize(baseSizeImage!, width: 383, height: 750);
        Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
        await _sunmiPrinter.dummyPrint(img: resizedUint8List);
      }

    // var base64Image = base64Encode(bytes);
    // await EzetapSdk.printBitmap(base64Image);
    //if (!mounted) return;
    // setState(() {
    //   _result = result;
    // });
  }

  Future<Uint8List> generateQR() async {
    // Create an image
    final image = img.Image(width: 150, height: 150);

    // Fill it with a solid color (white)
    img.fill(image, color: img.ColorRgb8(255, 255, 255));

    // Draw the barcode
    barcode_image.drawBarcode(
        image, barcode_image.Barcode.qrCode(), parkingData.vehicleno!,
        font: img.arial24);

    //var base64String = base64.encode(img.encodePng(image));
    return img.encodePng(image);
  }
}
