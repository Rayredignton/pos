import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pos/provider/printer_viewmodel.dart';
import 'package:pos/screens/printer.dart';
import 'package:pos/widgets/button.dart';


import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({Key? key}) : super(key: key);

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //   });
  // }
  String scan = "";
 Barcode? result;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinterViewmodel>(builder: (context, printerVM, child) {
      return Scaffold(
    
        body: ListView(
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            //  const YMargin(35),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              const SizedBox.shrink(),
                  Text(
                    "Scan Qr Code",
                    textAlign: TextAlign.center,
                    
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(height: 35,),

            Container(
              width: 200,
              height: 500,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(9))),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderRadius: 20,
                  cutOutSize: 300,
                ),
              ),
            ),

          const SizedBox(height: 35,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PButton(
                  backgroundColor: result != null
                      ? Colors.blue
                      : Colors.grey,
                  title: "Scan QR code",
                  onTap: () {
                    printerVM.qrcodes = result?.code.toString() ?? "";
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Printer()));
              
                    HapticFeedback.heavyImpact();
                    dispose();
                    controller!.dispose();
                    controller!.pauseCamera();
                  }),
            ),
                  const SizedBox(height: 15,),
           
          ],
        ),
      );
    });
  }

  _onQRViewCreated(QRViewController controller) {
    final nqrVM = Provider.of<PrinterViewmodel>(context, listen: false);
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
    });
  }

}
