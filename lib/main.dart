import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:barcode/src/pages/buscar.dart';
import 'package:barcode/src/pages/home.dart';
import 'package:barcode/src/pages/resp.dart';
import 'package:barcode/src/services/produto.serivice.dart';

void main() {
  WidgetsFlutterBinding();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductosServices(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
            ))),
      ),
    );
  }
}
