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
          title: Text('Código de barras URSoft'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Herramientas',
                onPressed: () {
                  _showDialog(context);
                },
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
                  String scannerCode = await FlutterBarcodeScanner.scanBarcode(
                      '#2D96F5', 'Cancelar', false, ScanMode.BARCODE);
                  productoServices.idCodigo = scannerCode;
                  if (scannerCode != '-1') {
                    return Navigator.popAndPushNamed(context, 'respuesta');
                    // return Navigator.pushNamed(context, 'respuesta');
                  }
                }),
              ),
              _boton(_textStyle, 'Buscar', Icons.search, () {
                Navigator.popAndPushNamed(context, 'buscar');
              }),
            ]),
          ),
        ));
  }

  _showDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: (prefs.getString('url') != null)
                ? Text('Enlazado al HOST')
                : Text('Agregar HOST'),
            content: Container(
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
