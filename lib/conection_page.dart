import 'dart:convert';

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
            Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Dispositivos conectados'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dispositivo: ',
                            style: TextStyle(fontWeight: FontWeight.bold),

                          ),
                          DropdownButton(
                            items: [],
                            value: _devicesList.isNotEmpty ? _device : null,
                          ),
                          ElevatedButton(
                            onPressed: _isButtonUnavailable
                                ? null : null,
                              //: _connecetd ? _disconect : _connect,
                            child: Text(_connecetd ? 'Desconecta' : 'Conecta')
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: new BorderSide(
                            color: _deviceState == 0
                                ? Colors.transparent
                                : _deviceState == 1
                                  ? Colors.green : Colors.red,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        elevation: _deviceState == 0 ? 4 : 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Dispositivo 1",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: _deviceState == 0
                                      ? Colors.green[600] 
                                      : Colors.red[600]
                                  ),
                                )
                              ),
                              ElevatedButton(
                                onPressed: _connecetd
                                  ? _sendOnMessageToBluetooth
                                  : null,
                                  child: Text("ON")
                              ),
                              ElevatedButton(
                                onPressed: _connecetd
                                ? _sendOnMessageToBluetooth
                                : null,
                                child: Text("OFF")
                              ),                              
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(color: Colors.blue,)
              ],
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Si no lo encuentras, agrega otro dispositivo en configuración"),
                    SizedBox(height: 15,),
                    ElevatedButton(
                      child: Text("Configuración de Bluetooth"),
                      onPressed: () {
                        FlutterBluetoothSerial.instance.openSettings();
                      },
                    )
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems(){
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1"+"\r\n"));
    await connection.output.allSent;
    show("Dispositivo encendido");
    setState(() {
      _deviceState = 1;
    });
  }
  
  Future show(String message, {Duration duration: const Duration(seconds: 3)}) async{
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(content: new Text(message), duration: duration,)
    );
  }

}
