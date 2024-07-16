import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_pothys_parking_app/screens/entry_screens/entry_screen.dart';
import 'package:sunmi_pothys_parking_app/screens/exit_screens/exit_screen.dart';
import 'package:sunmi_pothys_parking_app/screens/setting_screens/setting_screen.dart';
import 'package:sunmi_pothys_parking_app/services/provider_services/bottom_bar_provider.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';

import '../report_screen/report_screen_offline.dart';
import '../settlement_screens/settlement_screen_offline.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
        Consumer<BottomBarProvider>(builder: (context, bottomProvider, _) {
      return Scaffold(
        body: bottomProvider.bottomBarIndex == 0
            ? const EntryScreen()
            : bottomProvider.bottomBarIndex == 1
                ? const ExitScreen()
                : bottomProvider.bottomBarIndex == 2
                    ? const SettlementScreen()
                    : bottomProvider.bottomBarIndex == 3
                        ? const ReportScreen()
                        : const SettingScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.input),
              label: 'Entry',
            ),
            BottomNavigationBarItem(
              icon: Transform.rotate(
                  angle: 3.14, // Angle in radians (180 degrees)
                  child: const Icon(Icons.input)),
              // IconButton(icon : Transform.rotate(
              //       angle: 3.14, // Angle in radians (180 degrees)
              //       child: Icon(Icons.input)), onPressed: () {  }),
              label: 'Exit',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Settlements',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Reports',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: bottomProvider.bottomBarIndex,
          selectedItemColor: appThemeColor,
          // Color of the selected tab
          unselectedItemColor: Colors.grey,
          // Color of inactive tabs
          onTap: (v) {
            bottomProvider.bottomBarIndex = v;
          },
        ),
      );
    }));
  }
}
