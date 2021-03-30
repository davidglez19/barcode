import 'package:barcode/src/services/produto.serivice.dart';
import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productoServices = Provider.of<ProductosServices>(context);

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
                onPressed: () {},
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
                  _productoServices.idCodigo = scannerCode;
                  if (scannerCode != '-1') {
                    // return Navigator.popAndPushNamed(context, 'respuesta');
                    return Navigator.pushNamed(context, 'respuesta');
                  }
                }),
              ),
              _boton(_textStyle, 'Buscar', Icons.search, () {
                Navigator.pushNamed(context, 'buscar');
              }),
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
