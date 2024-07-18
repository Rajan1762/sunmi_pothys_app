import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';

import 'constants.dart';

showUpiAlertDialog({required BuildContext context,required String name, required String transactionNote,required double amount}) {
  // const String upiId = 'd.rajan1762-3@okhdfcbank';
  // final String name = 'Rajan';
  // final String transactionNote = 'Payment for testing';
  // final double amount = vehicleType == bikeString ? 50.0 : 100.0;
  // Generate UPI QR string

  //TODO
  // final String upiUrl = 'upi://pay?pa=$upiId&pn=$name&am=$amount&tn=$transactionNote';
  final String upiUrl = 'upi://pay?pa=BHARATPE907720031095@yesbankltd&pn=POTHYS PRIVATE LIMIT&am=$amount&cu=INR&tn=Pay To POTHYS PRIVATE LIMIT&tr=WHATSAPP_QR';

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: SizedBox(
            height: 315,
            width: 270,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Rs.${amount.toInt()}',style: TextStyle(color : appThemeColor ,fontSize: 24,fontWeight: FontWeight.w600)),
                  QrImageView(
                    data: upiUrl,
                    version: QrVersions.auto,
                    size: 212.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(EdgeInsets.symmetric(horizontal: 40))
                    ),
                      onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('Done'))
                ],
              ),
            ),
          ),
        );
      });
}

class SettlementHeaderWidget extends StatelessWidget {
  final String title;
  final Color materialColor;

  const SettlementHeaderWidget(
      {required this.title, required this.materialColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold, // Apply bold font
            fontSize: 20.0,
            color: materialColor, // Set font size
          ),
        ),
      ),
    );
  }
}

class SettlementSubWidget extends StatelessWidget {
  final String content;

  const SettlementSubWidget({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Center(
        child: Text(
          content,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Apply bold font
            fontSize: 20.0, // Set font size
          ),
        ),
      ),
    );
  }
}

class HyphenSizedBox extends StatelessWidget {
  const HyphenSizedBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Text(
          "-",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

// void showSnackBar(BuildContext context, String message) {
//   final snackBar = SnackBar(content: Text(message));
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
//
// void showAlertDialog(
//     BuildContext context, String title, String message, Function onPressed) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               onPressed();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
