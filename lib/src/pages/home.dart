import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barcode/src/services/produto.serivice.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productoServices = Provider.of<ProductosServices>(context);

    final size = MediaQuery.of(context).size;
    final _textStyle = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
        appBar: AppBar(
          title: Text('URSoft'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Herramientas',
                onPressed: () => _opciones(context),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width * 0.6,
            margin: EdgeInsets.only(
                left: size.width * 0.25, top: size.height * 0.25),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: _boton(_textStyle, 'Escaner', Icons.qr_code, () async {
                  // ===========================================================
                  // Verificación de la conexión
                  // ===========================================================
                  DataConnectionStatus status = await checkConnection();

                  // ===========================================================
                  // Activación del escaner
                  // ===========================================================

                  if (status == DataConnectionStatus.connected) {
                    final pref = await SharedPreferences.getInstance();
                    final urlHostExite = pref.containsKey('url');

                    if (urlHostExite) {
                      bool valor = false;
                      String scannerCode =
                          await FlutterBarcodeScanner.scanBarcode(
                              '#2D96F5', 'Cancelar', false, ScanMode.BARCODE);
                      productoServices.idCodigo = scannerCode;
                      print('VALOR SCANEADOS ========> $scannerCode');
                      if (scannerCode != '-1') {
                        return Navigator.popAndPushNamed(context, 'respuesta',
                            arguments: valor);
                        // return Navigator.pushNamed(context, 'respuesta');
                      }
                    } else {
                      _opciones(context);
                    }
                  } else {
                    _sinConexion(context);
                  }
                }),
              ),
              _boton(_textStyle, 'Buscar', Icons.search, () async {
                DataConnectionStatus status = await checkConnection();

                if (status == DataConnectionStatus.connected) {
                  final pref = await SharedPreferences.getInstance();
                  final urlHostExite = pref.containsKey('url');
                  (urlHostExite)
                      ? Navigator.pushNamed(context, 'buscar')
                      : _opciones(context);
                } else {
                  _sinConexion(context);
                }
              }),
              // ElevatedButton(onPressed: () => _opciones(context), child: Text('HOST'))
            ]),
          ),
        ));
  }

  Widget _boton(
      TextStyle _text, String _title, IconData _icono, Function data) {
    return ElevatedButton(
      onPressed: data,
      child: ListTile(
        title: Text(
          _title,
          style: _text,
        ),
        leading: Icon(
          _icono,
          color: Colors.white,
        ),
      ),
    );
  }
}

Future<void> _opciones(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (prefs.getString('url') != null)
              ? Text('Enlazado al HOST')
              : Text('Agregar HOST'),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 80,
              child: (prefs.getString('url') != null)
                  ? Text('${prefs.getString('url')}')
                  : TextField(
                      onChanged: (String valor) async {
                        await prefs.setString('url', valor);
                        final urlHost = prefs.getString('url');
                        print(urlHost);
                      },
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(labelText: 'URL HOST'),
                    ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Grabar',
                  style: TextStyle(color: Colors.green[800]),
                )),
            TextButton(
                onPressed: () async {
                  prefs.remove('url');
                  Navigator.pop(context);
                },
                child: Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar')),
          ],
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      });
}

Future<void> _sinConexion(BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.wifi_off,
            color: Color(0xffff0000),
            size: 35,
          ),
          content: Container(
            height: 152,
            child: Column(children: [
              Text(
                'Sin Conexión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Se ha perdido la conexión a internet verifique e intente de nuevo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff8a8a8a),
                ),
              ),
              Divider(),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: Color(0xffff0011)),
                  ))
            ]),
          ),
        );
      });
}

Future<DataConnectionStatus> checkConnection() async {
  // var listener = DataConnectionChecker().onStatusChange.listen((status) {
  //   switch (status) {
  //     case DataConnectionStatus.connected:
  //       print('Data connection is available.');
  //       break;
  //     case DataConnectionStatus.disconnected:
  //       print('You are disconnected from the internet.');
  //       break;
  //   }
  // });

  // close listener after 30 seconds, so the program doesn't run forever
  // await Future.delayed(Duration(milliseconds: 1000));
  // await listener.cancel();

  return await DataConnectionChecker().connectionStatus;
}
