import 'package:flutter/material.dart';
import 'package:pos/provider/printer_viewmodel.dart';
import 'package:pos/widgets/button.dart';
import 'package:provider/provider.dart';


class Printer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
      return Consumer<PrinterViewmodel>(builder: (context, printerVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Bluetooth Printer'),
          ),
          body: Column(
            children: [
              // Display the connected device
              if (printerVM.connectedDevice != null)
                Text('Connected to: ${printerVM.connectedDevice!.name}'),
              SizedBox(height: 20),
        
              // Scan for and display Bluetooth devices
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: PButton(
                  onTap: () async {
                    await printerVM.scanForDevices();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Select Printer'),
                          content: Container(
                            height: 200,
                            child: ListView.builder(
                              itemCount:printerVM.devices.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(printerVM.devices[index].name!),
                                  onTap: () {
                                   printerVM.connectToPrinter(printerVM.devices[index]);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  title: 'Select Printer',
                            
                ),
              ),
          SizedBox(height: 20),
              // Print Receipt Button
              Padding(
             padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: PButton(
                  onTap: (){printerVM.connectedDevice != null
                      ? () {
                         printerVM.printReceipt();
                        }
                      : null;},
                         title: 'Print Receipt',
                             
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
