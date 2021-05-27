import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum pageState{
  havePairedDevices,
  empty
}

class ConectionPage extends StatefulWidget {
  @override
  _ConectionPageState createState() => _ConectionPageState();
}

class _ConectionPageState extends State<ConectionPage> {

  FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;
  BluetoothDevice mixer;
  String op = "00 Foot"; //what is this??

  pageState _currentState = pageState.empty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexiones con Blutooth'),
      ),
      body: Column(
        children: [
          (_currentState == pageState.empty) ?
            Text('No tienes ningún dispositivo') :
            Text('Holaaa')
        ],
      ),
    );
  }
}
