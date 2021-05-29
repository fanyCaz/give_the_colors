import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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


  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;
  int _deviceState ;
  bool isDisconnecting = false;

  bool get isConnected => connection != null && connection.isConnected;
/*  FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;
  BluetoothDevice mixer;
  String op = "00 Foot"; //what is this??
******/
  pageState _currentState = pageState.empty;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connecetd = false;
  bool _isButtonUnavailable = false;
  //List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state){
      setState(() {
        _bluetoothState = state;
      });
    });
    _deviceState = 0;

    enableBluetooth();
    FlutterBluetoothSerial.instance
    .onStateChanged()
    .listen((BluetoothState state) {
     setState(() {
       _bluetoothState = state;
       if(_bluetoothState == BluetoothState.STATE_OFF){
         _isButtonUnavailable = true;
       }
       getPairedDevices();
     });
    });
  }

  @override
  void dispose() {
    if(isConnected){
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if(_bluetoothState == BluetoothState.STATE_OFF){
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    }else{
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try{
      devices = await _bluetoothSerial.getBondedDevices();
    } on PlatformException {
      print("Hubo un error en el obtener los dispositivos");
    }

    if(!mounted){
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  /*void startDiscovery()async{
    var streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((event) {
      results.add(event);
    });

    streamSubscription.onDone(() async {
      if(results.isNotEmpty) {
        // Some simplest connection :F
        setState(() {
          _currentState = pageState.havePairedDevices;
        });
      }
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexiones con Blutooth'),
      ),
      body: Column(
        children: [
          (_bluetoothState.isEnabled) ?
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent)
              ),
              icon: Icon(Icons.bluetooth),
              label: Text('Apaga tu Bluetooth'),
              onPressed: ()async{
                await FlutterBluetoothSerial.instance.requestDisable();
              },
            ) :
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent)
              ),
              icon: Icon(Icons.bluetooth),
              label: Text('Enciende tu Bluetooth'),
              onPressed: () async {
                await FlutterBluetoothSerial.instance.requestEnable();
              },
            ),
          (_currentState == pageState.empty) ?
            ElevatedButton(
              onPressed: () async {
                await getPairedDevices().then((value){
                  print("Se refresco la lista");
                  //show('Lista Refrescada');
                });
              },
              child: Text('Refresca para ver dispositivos')
            ) :
            Text('Holaaa'),
        ],
      ),
    );
  }
}
