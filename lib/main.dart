import 'package:flutter/material.dart';
import 'package:give_the_colors/bluetooth.dart';
import 'package:give_the_colors/conection_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colores',
      initialRoute: '/',
      routes: {
        '/conection': (context) => ConectionPage(),
        '/bluetooth': (context) => BluetoothApp()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  final String title = 'Color Mixer';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                //blutooth logo
                Text('Conectar')
              ],
            ),
            Row(
              children: [
                Text('Conexión con ....')
              ]
            ),
            Row(
              children: [
                Text('Color Picker')
              ],
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context,'/bluetooth');
              },
              child: Text('Conecta un dispositivo')
            ),
            Text('Hola')
          ],
        )
      )
    );
  }
}
