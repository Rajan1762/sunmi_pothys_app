import 'package:flutter/material.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';
import 'package:sunmi_pothys_parking_app/utils/styles.dart';
import 'dart:async';

import '../models/parking_data_model.dart';
import 'common_values.dart';


void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void showCustomAlertDialog(
{required BuildContext context, String? title, String? message, Function? onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title!=null?Text(title,style: TextStyle(color: appThemeColor),textAlign: TextAlign.center):null,
        content: message!=null?Text(message,):null,
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed??();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showAlertDialogWithCancel(
    {required BuildContext context,
      required String title,
      required String message,
      required Function(BuildContext,bool, ParkingDataModel?) onPressedFun,
      required ParkingDataModel? parkingDataModel}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              print('showAlertDialogWithCancel parkingDataModel.vehicleNo = ${parkingDataModel?.vehicleno}');
              onPressedFun(context,true, parkingDataModel);
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              cancelReprintStatus=true;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Utils {
  static void showAlertDialog(
      BuildContext context, String title, String message, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                onPressed();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showAlertDialogWithCancel(BuildContext context,
      String title, String message, Function onPressed) async {
    Completer<void> completer = Completer<void>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                onPressed(true);
                completer.complete(); // Signal completion
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(); // Signal completion
              },
            ),
          ],
        );
      },
    );
    await completer.future; // Wait until the completer is completed
  }

  static void showBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(message),
        );
      },
    );
  }

  // static void showSnackBar(BuildContext context, String message) {
  //   final snackBar = SnackBar(content: Text(message));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  static Future<void> showSnackBarPadding(
      BuildContext context, String text) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    ));
  }
}

// example how to use in other class files
/*
import 'package:flutter/material.dart';
import 'package:your_package_name_here/utils/app_utils.dart'; // Import your utility class

class YourPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example usage of utility methods
            AppUtils.showBottomSheet(context, 'This is a bottom sheet message');
            AppUtils.showSnackBar(context, 'This is a snackbar message');

            AppUtils.showAlertDialog(context, 'Alert', 'This is an alert message', () {
            // Optional callback function to execute after pressing OK
            print('OK pressed');
            });


          },
          child: Text('Show Dialogs'),
        ),
      ),
    );
  }
}

*/
