import 'package:barcode/src/pages/buscar.dart';
import 'package:barcode/src/pages/home.dart';
import 'package:barcode/src/pages/resp.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'buscar': (_) => BuscarPage(),
        'respuesta': (_) => RespuestaPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.teal[500],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(10),
            backgroundColor: MaterialStateProperty.all(Colors.teal[700]),
          )
        )
      ),
    );
  }
}