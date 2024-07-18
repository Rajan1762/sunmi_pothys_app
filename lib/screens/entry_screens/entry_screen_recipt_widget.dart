import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/parking_data_model.dart';
import '../../utils/constants.dart';

class EntryScreenReceiptWidget extends StatelessWidget {
  final ParkingDataModel parkingData;
  final Uint8List qrBytes;
  final bool reprintStatus;

  const EntryScreenReceiptWidget(
      {super.key,
        required this.parkingData,
        required this.qrBytes,
        required this.reprintStatus});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          height: 818,
          width: receiptWidth,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/app-logo.png', width: 120, height: 120),
              Text(
                'POTHYS PRIVATE LIMITED',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: receiptTextSize,
                    //height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'No 407/7,GST Road,Zamin Pallavaram',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: receiptTextSize,
                    //height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'Chrompet, Chennai - 600 044',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: receiptTextSize,
                    //height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'Ph: 044-22380120, 21, 22',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: receiptTextSize,
                    //height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10.0),
              Text(
                '*** Pothys Parking ${reprintStatus ? 'Claim Receipt' : 'Receipt'} ***',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: receiptTextSize,
                    //height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Row(children: [
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'V. NO',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: receiptTextSize,
                          ////height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  ': ${parkingData.vehicleno}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              Row(children: [
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'V. TYPE',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: receiptTextSize,
                          ////height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  ': ${parkingData.vehicletype}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              Row(children: [
                Container(
                  width: 150,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'ENTRY ON',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: receiptTextSize,
                        ////height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Text(
                  ': ${parkingData.indate}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              Row(children: [
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'ENTRY AMT',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: receiptTextSize,
                          ////height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  ': Rs.${reprintStatus ? '0':  parkingData.amount} / 3Hrs',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              Row(children: [
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Payment Mode',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: receiptTextSize,
                          ////height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  ': ${parkingData.paymode}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              Row(children: [
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'IN GATE',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: receiptTextSize,
                          ////height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  ': ${parkingData.counter}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              Row(children: [
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'IN USER',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: receiptTextSize,
                          ////height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Text(
                  ': ${parkingData.userid}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              const SizedBox(height: 10.0),
              Image.memory(
                Uint8List.fromList(qrBytes),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                child: Text(
                  '1.Car-Rs.100 per 3Hr, Extra Hrs-50Rs/hour.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      //height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('2.Bike-Rs.50 per 3Hr, Extra Hrs-20Rs/hour.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getReceiptWidget({required parkingData,
  required qrBytes,
  required reprintStatus}) {
  return Column(
    children: [
      Expanded(
        child: Material(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 2)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/app-logo.png', width: 100, height: 100),
                Text(
                  'POTHYS PRIVATE LIMITED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      //height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'No 407/7,GST Road,Zamin Pallavaram,\nChrompet, Chennai - 600 044',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      //height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'Ph: 044-22380120, 21, 22',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      //height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 5.0),
                Text(
                  '*** Pothys Parking ${reprintStatus ? 'Claim Receipt' : 'Receipt'} ***',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: receiptTextSize,
                      //height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                ReceiptRowWidget(title: 'V. NO', value: '${parkingData.vehicleno}'),
                ReceiptRowWidget(
                    title: 'V. TYPE', value: '${parkingData.vehicletype}'),
                ReceiptRowWidget(title: 'ENTRY ON', value: '${parkingData.indate}'),
                ReceiptRowWidget(title: 'ENTRY AMT',
                    value: 'Rs.${reprintStatus ? '0' : parkingData.amount} / 3Hrs'),
                ReceiptRowWidget(
                    title: 'Payment Mode', value: '${parkingData.paymode}'),
                ReceiptRowWidget(title: 'IN GATE', value: '${parkingData.counter}'),
                ReceiptRowWidget(title: 'IN USER', value: '${parkingData.userid}'),
                const SizedBox(height: 6.0),
                Image.memory(
                  Uint8List.fromList(qrBytes),
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 6.0),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(
                    '1.Car-Rs.100 per 3Hr, Extra Hrs-50Rs/hour.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        //height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('2.Bike-Rs.50 per 3Hr, Extra Hrs-20Rs/hour.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 1)
    ],
  );
}

class ReceiptRowWidget extends StatelessWidget {
  final String title;
  final String value;
  const ReceiptRowWidget({
    super.key, required this.title, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 2,
        child: Container(
            width: 150,
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              // 'V. NO',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: receiptTextSize,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )),
      ),
      Text(' : ',style: TextStyle(
          fontSize: receiptTextSize,
          ////height: 1.5,
          fontWeight: FontWeight.bold,
          color: Colors.black)),
      Expanded(
        flex: 3,
        child: Text(
          value,
          // ': ${parkingData.vehicleno}',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: receiptTextSize,
              ////height: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
    ]);
  }
}
