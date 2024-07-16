import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sunmi_pothys_parking_app/models/parking_data_model.dart';
import '../../models/parking_data.dart';

class ExitReceiptWidget extends StatefulWidget {
  final ParkingDataModel parkingData;
  // final Uint8List qr_bytes;

  const ExitReceiptWidget(
      {Key? key, required this.parkingData})
      : super(key: key);

  @override
  _ExitReceiptWidgetState createState() => _ExitReceiptWidgetState();
}

//Container/SingleChildScrollView
class _ExitReceiptWidgetState extends State<ExitReceiptWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Image.asset('assets/app-logo.png', width: 120, height: 120),
          const Text(
            'POTHYS PRIVATE LIMITED',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            'No 407/7,GST Road,Zamin Pallavaram',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const Text(
            'Chrompet, Chennai - 600 044',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const Text(
            'Ph: 044-22380120, 21, 22',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(height: 10.0),
          const Text(
            '** Extra Hours Parking Charge **',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'V. NO',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.vehicleno}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'V. TYPE',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.vehicletype}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: EdgeInsets.only(left: 10),
                child: const Text(
                  'ENTRY ON',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Container(
                child: Text(
                  ': ${widget.parkingData.indate}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: EdgeInsets.only(left: 10),
                child: const Text(
                  'ENTRY AMT',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': Rs.${widget.parkingData.amount} / 3Hrs',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Payment Mode',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.paymode}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'IN GATE',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.counter}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'IN USER',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.userid}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: EdgeInsets.only(left: 10),
                child: const Text(
                  'DURATION',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.duration}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'EXIT ON',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Container(
                child: Text(
                  ': ${widget.parkingData.outdate}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'EXIT AMT',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': Rs.${widget.parkingData.outamount}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Payment Mode',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.outpaymode}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'OUT GATE',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.outcounter}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          Row(children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'OUT USER',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ////height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              ': ${widget.parkingData.outuserid}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 18,
                  ////height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ]),
          const SizedBox(height: 5.0),
          /*
          Image.memory(
    Uint8List.fromList(widget.qr_bytes),
    width: 120,
    height: 120,
    fit: BoxFit.cover,
          ),
          SizedBox(height: 20.0),
          */
          /*
          Text(
    '----- T & C -----',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '1.Car-Rs 100 per 3Hr, Extra Hrs-50Rs per hour.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '2.Bike-Rs 50 per 3Hr, Extra Hrs-20Rs per hour.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '3.Parking amount will be adjusted, in your purchase only.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '4.Parking ticket to be produced in the cash counter for adjustment against your purchase value.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '5.No refund if not redeemed in cash counter or not purchased.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '6.Minimum purchase value Rs. 500 for redeeming the parking ticket.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '7.Over night / misuse of parking premises-500 rs will collected as fine.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '8.Vehicles parked are at the willingness and at the own risk of the  vehicle owner.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),
          Text(
    '9.The management accepts no liability for loss or damage caused to any vehicle or its contents in the parking premises.',
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 16,
        //height: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.black),
          ),

          */
        ],
      ),
    );
  }
}
