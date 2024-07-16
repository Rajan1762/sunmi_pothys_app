import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_pothys_parking_app/screens/home_screens/home_main_screen.dart';
import 'package:sunmi_pothys_parking_app/screens/profile_screens/login_screen.dart';
import 'package:sunmi_pothys_parking_app/services/database_services/database_helper_classes/vehicle_db_helper_class.dart';
import 'package:sunmi_pothys_parking_app/services/provider_services/bottom_bar_provider.dart';
import 'package:sunmi_pothys_parking_app/services/provider_services/vehicle_provider.dart';
import 'package:sunmi_pothys_parking_app/utils/colors.dart';
import 'package:sunmi_pothys_parking_app/utils/common_values.dart';
import 'package:sunmi_pothys_parking_app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _getSharedPrefValue();
  await getDeviceInfo();
  runApp(const MyApp());
}

_getSharedPrefValue() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  loginUserName = prefs.getString(loginUserNameString) ?? '';
  dbHelper = VehicleDatabaseHelper.instance;
}

Future getDeviceInfo()async{
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
    Map<String, dynamic> deviceDetails = {
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  // printFullString('deviceDetails = $deviceDetails');
  deviceSerialNo = deviceDetails['serialNumber'];
  print('deviceSerialNo = $deviceSerialNo');
}

void printFullString(String text) {
  const int chunkSize = 100;
  int start = 0;
  while (start < text.length) {
    int end = (start + chunkSize < text.length) ? start + chunkSize : text.length;
    print(text.substring(start, end));
    start = end;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomBarProvider>(create: (_) => BottomBarProvider()),
        ChangeNotifierProvider<VehicleProvider>(create: (_) => VehicleProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color?>(appThemeColor),
                foregroundColor: WidgetStateProperty.all<Color?>(Colors.white)
              )
            )
          ),
          home: loginUserName != '' ? const HomeMainScreen() : const LoginScreen()),
    );
  }
}
