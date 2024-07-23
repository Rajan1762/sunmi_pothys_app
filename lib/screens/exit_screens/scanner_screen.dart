import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/common_values.dart';

// class QRCodeScanner extends StatefulWidget {
//   @override
//   _QRCodeScannerState createState() => _QRCodeScannerState();
// }
//
// class _QRCodeScannerState extends State<QRCodeScanner> {
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//   final BarcodeScanner _barcodeScanner = BarcodeScanner();
//
//   @override
//   void initState(){
//     super.initState();
//     _ini();
//     WidgetsBinding.instance.addPostFrameCallback((_) async{
//       Future.delayed(const Duration(seconds: 1),(){
//         _initializeCamera();
//       });
//     });
//   }
//
//   _ini() async
//   {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//
//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//     );
//     setState(() {});
//   }
//
//   void _initializeCamera() async {
//
//     _initializeControllerFuture = _controller?.initialize();
//     setState(() {});
//
//     _controller?.startImageStream((CameraImage image) async {
//       try {
//         final WriteBuffer allBytes = WriteBuffer();
//         for (Plane plane in image.planes) {
//           allBytes.putUint8List(plane.bytes);
//         }
//         final bytes = allBytes.done().buffer.asUint8List();
//
//         final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//
//         InputImageMetadata inputImageData = InputImageMetadata(size: imageSize,
//             rotation: InputImageRotation.rotation0deg,
//             format: InputImageFormat.yuv420, bytesPerRow: 10000);
//
//         final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
//
//         final barcodes = await _barcodeScanner.processImage(inputImage);
//
//         for (Barcode barcode in barcodes) {
//           print('Barcode found! ${barcode.rawValue}');
//           scannedValue.clear();
//           scannedValue.write(barcode.rawValue);
//           if(context.mounted){
//             Navigator.of(context).pop();
//           }
//         }
//       } catch (e) {
//         print("Error processing image: $e");
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     _barcodeScanner.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('QR Code Scanner')),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller!);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }

//TODO
// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});
//
//   @override
//   State<ScannerScreen> createState() => _ScannerScreenState();
// }
//
// class _ScannerScreenState extends State<ScannerScreen> {
//   bool tStatus = true;
//   bool torchLightStatus = true;
//
//   VoidCallback? onPressed;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async{
//       onPressed = (){
//         BarcodeScanner.toggleFlashlight();
//         torchLightStatus = !torchLightStatus;
//         setState(() {});
//       };
//
//       Future.delayed(const Duration(seconds: 1),(){
//         onPressed!();
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Stack(
//         children: [
//           Positioned.fill(child: BarcodeScannerWidget(
//             scannerType: ScannerType.barcode,
//             onBarcodeDetected: (qrCode) async {
//               print('qrCode.value = ${qrCode.value}');
//               scannedValue.clear();
//               scannedValue.write(qrCode.value);
//               Navigator.of(context).pop();
//             },
//             onError: (e) {
//               debugPrint('Error Occurred e = $e');
//               showCustomAlertDialog(context: context,title: 'Error',message: e.toString());
//               Navigator.of(context).pop();
//             },
//           )),
//           Align(alignment: Alignment.center, child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 60),
//             child: Divider(color: Colors.red[400], thickness: 1),
//           )),
//           Center(child: Container(margin: const EdgeInsets.symmetric(horizontal: 60), width: double.infinity, height: 220, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(15)))),
//           Positioned(
//               top: 50,
//               right: 30,
//               child: GestureDetector(
//                   onTap: onPressed,
//                   child: Icon(!torchLightStatus ? Icons.flashlight_on :Icons.flashlight_on_outlined,color: Colors.grey,size: 30,)))
//         ],
//       ),
//     );
//   }
// }

//---------------------------------------------------------------------------------------------
//TODO

class ScannerScreen extends StatelessWidget {
  ScannerScreen({super.key});
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    torchEnabled: true
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 800,
          width: MediaQuery.of(context).size.width,
          child: AiBarcodeScanner(
            hideGalleryButton: false,
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              print('capture = $capture');
              scannedValue.clear();
              scannedValue.write(capture.barcodes.first.rawValue);
              if (kDebugMode) {
                print("Barcode scanned: ${scannedValue.toString()}");
              }
              _scannerController.stop();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
