import 'package:flutter/material.dart';
import '../../models/report_pg_model.dart';
import '../../models/settlement_pg_model.dart';
import '../../utils/common_widget.dart';

class ReportPgReceiptWidget extends StatelessWidget {
  final int bikeCount;
  final int carCount;
  final String currentDate;

  const ReportPgReceiptWidget({required this.bikeCount,
    required this.carCount,
    required this.currentDate,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black,
        //     blurRadius: 02,
        //   ),
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/app-logo.png', width: 100, height: 100),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'POTHYS PRIVATE LIMITED',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ), const SizedBox(
            height: 10,
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
            height: 30,
          ),
          const Row(
            children: [
              Expanded(
                  child: SettlementHeaderWidget(
                      title: 'Type', materialColor: Colors.black)),
              Expanded(
                  child: SettlementHeaderWidget(
                      title: 'Count', materialColor: Colors.black)),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Bike')),
              Expanded(
                  child: SettlementSubWidget(
                      content: bikeCount.toString())),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Car')),
              Expanded(
                  child: SettlementSubWidget(
                      content: carCount.toString())),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Total')),
              Expanded(
                  child: SettlementSubWidget(
                      content: "${bikeCount + carCount}")),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getReportPgReceiptWidget({required entryBikeCount,required exitBikeCount,
required entryCarCount,required exitCarCount,
required currentDate})
{
  return Container(
    margin: const EdgeInsets.all(1),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all()
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/app-logo.png', width: 100, height: 100),
        const SizedBox(
          height: 5,
        ),
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
          height: 30,
        ),
        const Row(
          children: [
            Expanded(
                child: SettlementHeaderWidget(
                    title: 'Type', materialColor: Colors.black)),
            Expanded(
                child: SettlementHeaderWidget(
                    title: 'Entry Count', materialColor: Colors.black)),
            Expanded(
                child: SettlementHeaderWidget(
                    title: 'Exit Count', materialColor: Colors.black)),
          ],
        ),
        Row(
          children: [
            const Expanded(child: SettlementSubWidget(content: 'Bike')),
            Expanded(
                child: SettlementSubWidget(
                    content: entryBikeCount.toString())),
            Expanded(
                child: SettlementSubWidget(
                    content: exitBikeCount.toString())),
          ],
        ),
        Row(
          children: [
            const Expanded(child: SettlementSubWidget(content: 'Car')),
            Expanded(
                child: SettlementSubWidget(
                    content: entryCarCount.toString())),
            Expanded(
                child: SettlementSubWidget(
                    content: exitCarCount.toString())),
          ],
        ),
        Row(
          children: [
            const Expanded(child: SettlementSubWidget(content: 'Total')),
            Expanded(
                child: SettlementSubWidget(
                    content: "${entryBikeCount + entryCarCount}")),
            Expanded(
                child: SettlementSubWidget(
                    content: "${exitBikeCount + exitCarCount}")),
          ],
        ),
      ],
    ),
  );
}

class SettlementAllCounterReceiptWidget extends StatefulWidget {
  final List<SettlementOverallModel?>? settlementData;
  final String currentDate;
  const SettlementAllCounterReceiptWidget({super.key, this.settlementData, required this.currentDate});

  @override
  State<SettlementAllCounterReceiptWidget> createState() => _SettlementAllCounterReceiptWidgetState();
}

class _SettlementAllCounterReceiptWidgetState extends State<SettlementAllCounterReceiptWidget> {
  SettlementPgModel? g1CounterDataList;
  SettlementPgModel? g2CounterDataList;
  SettlementPgModel? g3CounterDataList;
  SettlementPgModel? g4CounterDataList;
  SettlementPgModel? g5CounterDataList;
  SettlementPgModel? g6CounterDataList;

  SettlementPgModel _assignSettlementData(
      {required SettlementOverallModel? element}) {
    SettlementPgModel? settlementPgModel = SettlementPgModel();
    element?.vehicleType == 'BIKE'
        ? settlementPgModel.CARD_BIKE_Count = '${element?.count}'
        : settlementPgModel.CARD_CAR_Count = '${element?.count}';

    element?.payMode == 'CASH' ? settlementPgModel.CASH_Amount = '${element?.amount}' :
    element?.payMode == 'UPI' ? settlementPgModel.UPI_Amount = '${element?.amount}' :
    settlementPgModel.CARD_Amount = '${element?.amount}';

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
    return settlementPgModel;
  }

  _getOverAllData() {
    if (widget.settlementData != null) {
      widget.settlementData?.forEach((element) {
        if (element?.userid != null) {
          switch (element?.userid) {
            case 'G1':
              g1CounterDataList = _assignSettlementData(element: element);
              break;
            case 'G2':
              g2CounterDataList = _assignSettlementData(element: element);
              break;
            case 'G3':
              g3CounterDataList = _assignSettlementData(element: element);
              break;
            case 'G4':
              g4CounterDataList = _assignSettlementData(element: element);
              break;
            case 'G5':
              g5CounterDataList = _assignSettlementData(element: element);
              break;
            case 'G6':
              g6CounterDataList = _assignSettlementData(element: element);
              break;
            default:
              break;
          }
        }
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _getOverAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 02,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/app-logo.png', width: 100, height: 100),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'POTHYS PRIVATE LIMITED',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ), const SizedBox(
            height: 10,
          ),
          Text(
            widget.currentDate,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  SettlementPgModel? counterValue = g1CounterDataList;
                  if (index == 0) {
                    counterValue = g1CounterDataList;
                  } else if (index == 1) {
                    counterValue = g2CounterDataList;
                  } else if (index == 2) {
                    counterValue = g3CounterDataList;
                  } else if (index == 3) {
                    counterValue = g4CounterDataList;
                  } else if (index == 4) {
                    counterValue = g5CounterDataList;
                  } else {
                    counterValue = g6CounterDataList;
                  }
                  return Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(child: SettlementHeaderWidget(
                              title: 'Mode', materialColor: Colors.green)),
                          Expanded(child: SettlementHeaderWidget(
                              title: 'Amount', materialColor: Colors.green)),
                          Expanded(child: SettlementHeaderWidget(
                              title: 'Car', materialColor: Colors.green)),
                          Expanded(child: SettlementHeaderWidget(
                              title: 'Bike', materialColor: Colors.green)),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: SettlementSubWidget(
                              content: 'Cash')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: "\u{20B9}${counterValue?.CASH_Amount ?? 0}")),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: counterValue?.CASH_CAR_Count ?? '0')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content:counterValue?.CASH_BIKE_Count ?? '0')),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: SettlementSubWidget(
                              content: 'Card')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: '\u{20B9}${counterValue?.CARD_Amount ?? 0}')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: counterValue?.CARD_CAR_Count ?? '0')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: counterValue?.CARD_BIKE_Count ?? '0')),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: SettlementSubWidget(
                              content: 'UPI')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content:'\u{20B9}${counterValue?.UPI_Amount ?? 0}')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content:counterValue?.UPI_CAR_Count ?? '0')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: counterValue?.UPI_BIKE_Count ?? '0'
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: SettlementSubWidget(
                              content: 'Total')),
                          Expanded(
                              child:
                              SettlementSubWidget(
                                  content: '\u{20B9}${counterValue?.totalAmount ?? 0}')),
                          Expanded(child: SettlementSubWidget(
                              content: '${counterValue?.totalCarCount ?? 0}')),
                          Expanded(
                              child: SettlementSubWidget(
                                  content: '${counterValue?.totalBikeCount ?? 0}')),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class SettlementPgAllCounterReceiptWidget extends StatelessWidget {
  final SettlementPgModel? settlementData;
  final String currentDate;
  final int totalAmount;
  final  int totalCarCount;
  final int totalBikeCount;

  const SettlementPgAllCounterReceiptWidget({this.settlementData,
    required this.currentDate,required this.totalAmount,required this.totalBikeCount,required this.totalCarCount,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 02,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/app-logo.png', width: 100, height: 100),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'POTHYS PRIVATE LIMITED',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
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
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 20),
            child: Text('Counter : ${settlementData?.counterNumber}',style: const TextStyle(
              fontWeight: FontWeight.bold, // Apply bold font
              fontSize: 20.0, // Set font size
            )),
          ),
          const Row(
            children: [
              Expanded(child: SettlementHeaderWidget(title: 'Mode',materialColor: Colors.black)),
              Expanded(child: SettlementHeaderWidget(title: 'Amount',materialColor: Colors.black)),
              Expanded(child: SettlementHeaderWidget(title: 'Car',materialColor: Colors.black)),
              Expanded(child: SettlementHeaderWidget(title: 'Bike',materialColor: Colors.black)),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Cash')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? '\u{20B9}${settlementData?.CASH_Amount ?? 0}'
                          : '\u{20B9} 0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CASH_CAR_Count ?? '0'
                          : '0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CASH_BIKE_Count ?? '0'
                          : '0')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Card')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? '\u{20B9}${settlementData?.CARD_Amount ?? 0}'
                          : '\u{20B9} 0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CARD_CAR_Count ?? '0'
                          : '0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CARD_BIKE_Count ?? '0'
                          : '0')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'UPI')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? '\u{20B9}${settlementData?.UPI_Amount ?? 0}'
                          : '\u{20B9} 0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.UPI_CAR_Count ?? '0'
                          : '0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.UPI_BIKE_Count ?? '0'
                          : '0')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Total')),
              Expanded(
                  child:
                  SettlementSubWidget(content: '\u{20B9}$totalAmount')),
              Expanded(child: SettlementSubWidget(content: '$totalCarCount')),
              Expanded(
                  child: SettlementSubWidget(content: '$totalBikeCount')),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Device ID : ${settlementData?.deviceNumber}',style: const TextStyle(
                fontWeight: FontWeight.bold, // Apply bold font
                fontSize: 20.0, // Set font size
              ))
          )
        ],
      ),
    );
  }
}

class SettlementPgReceiptWidget extends StatelessWidget {
  final SettlementPgModel? settlementData;
  final String currentDate;
  final int totalAmount;
  final  int totalCarCount;
  final int totalBikeCount;

  const SettlementPgReceiptWidget({this.settlementData,
    required this.currentDate,required this.totalAmount,required this.totalBikeCount,required this.totalCarCount,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 02,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/app-logo.png', width: 100, height: 100),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'POTHYS PRIVATE LIMITED',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                //height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ), const SizedBox(
            height: 10,
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
            height: 30,
          ),
          const Row(
            children: [
              Expanded(child: SettlementHeaderWidget(title: 'Mode',materialColor: Colors.black)),
              Expanded(child: SettlementHeaderWidget(title: 'Amount',materialColor: Colors.black)),
              Expanded(child: SettlementHeaderWidget(title: 'Car',materialColor: Colors.black)),
              Expanded(child: SettlementHeaderWidget(title: 'Bike',materialColor: Colors.black)),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Cash')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? '\u{20B9}${settlementData?.CASH_Amount ?? 0}'
                          : '\u{20B9} 0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CASH_CAR_Count ?? '0'
                          : '0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CASH_BIKE_Count ?? '0'
                          : '0')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Card')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? '\u{20B9}${settlementData?.CARD_Amount ?? 0}'
                          : '\u{20B9} 0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CARD_CAR_Count ?? '0'
                          : '0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.CARD_BIKE_Count ?? '0'
                          : '0')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'UPI')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? '\u{20B9}${settlementData?.UPI_Amount ?? 0}'
                          : '\u{20B9} 0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.UPI_CAR_Count ?? '0'
                          : '0')),
              Expanded(
                  child: SettlementSubWidget(
                      content: settlementData != null
                          ? settlementData?.UPI_BIKE_Count ?? '0'
                          : '0')),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SettlementSubWidget(content: 'Total')),
              Expanded(
                  child:
                  SettlementSubWidget(content: '\u{20B9}$totalAmount')),
              Expanded(child: SettlementSubWidget(content: '$totalCarCount')),
              Expanded(
                  child: SettlementSubWidget(content: '$totalBikeCount')),
            ],
          ),
        ],
      ),
    );
  }
}