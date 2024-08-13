import 'dart:async';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';

class PrinterViewmodel extends ChangeNotifier {


  String _qrcodes = "";
  String get qrcodes => _qrcodes;
  set qrcodes(String value) {
    _qrcodes = value;
    notifyListeners();
  }


  BluetoothManager bluetoothManager = BluetoothManager.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _connectedDevice;

  List<BluetoothDevice> get devices => _devices;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  Future<void> scanForDevices() async {
    _devices.clear();
    notifyListeners();

    // Assuming startScan() returns Future<List<BluetoothDevice>>
    List<BluetoothDevice> scannedDevices = await bluetoothManager.startScan();
    
    _devices = scannedDevices;
    notifyListeners();

    // Optionally, stop scanning after a certain duration
    await Future.delayed(Duration(seconds: 5));
    bluetoothManager.stopScan();
  }

  Future<void> connectToPrinter(BluetoothDevice device) async {
    await bluetoothManager.connect(device);
    _connectedDevice = device;
    notifyListeners();
  }

  Future<void> disconnectPrinter() async {
    await bluetoothManager.disconnect();
    _connectedDevice = null;
    notifyListeners();
  }

  Future<void> printReceipt() async {
    if (_connectedDevice != null) {
      final isConnected = await bluetoothManager.isConnected;

      if (isConnected!) {
        List<int> receiptData = await _generateReceipt(PaperSize.mm80);
        bluetoothManager.writeData(receiptData);
      } else {
        print('Printer not connected');
      }
    } else {
      print('No printer connected');
    }
  }

  Future<List<int>> _generateReceipt(PaperSize paper) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.text('Flutter Ventures',
        styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2));
    bytes += generator.text('137 Toyin Street',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Ikeja, LAgos',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    // Itemized List
    bytes += generator.row([
      PosColumn(text: 'Item', width: 6),
      PosColumn(text: 'Qty', width: 2),
      PosColumn(text: 'Price', width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Widget', width: 6),
      PosColumn(text: '2', width: 2),
      PosColumn(text: 'NGN5.00', width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();
    bytes += generator.text('Total: NGN100.00', styles: PosStyles(align: PosAlign.right, bold: true));
    bytes += generator.hr();

    bytes += generator.text('Date: 2024-08-13 14:32',
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Payment: Crypto',
        styles: PosStyles(align: PosAlign.left));

    bytes += generator.cut();
    return bytes;
  }
}
