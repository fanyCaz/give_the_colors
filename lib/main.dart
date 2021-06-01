import 'package:flutter/material.dart';
import 'package:give_the_colors/bluetooth.dart';

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
        '/bluetooth': (context) => BluetoothApp()
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //blutooth logo
                  Text('Bienvenido a Color Mixer',
                    style: TextStyle(
                        fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context,'/bluetooth');
              },
              child: Text('¡Empieza a combinar!'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * .3,100),
                primary: Colors.deepPurple,
              ),
            ),
          ],
        )
      )
    );
  }
}
