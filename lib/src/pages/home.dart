import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final _textStyle = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title:Text('Código de barras URSoft') ,),
      body: Container(
        width: size.width * 0.6,
        margin: EdgeInsets.only(left: size.width * 0.25, top: size.height * 0.25),
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: _boton(_textStyle, 'Escaner',Icons.qr_code, () async {
                // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                //                                     '#2D96F5', 
                //                                     'Cancelar', 
                //                                     false, 
                //                                     ScanMode.BARCODE);

              }),
            ),
            _boton(_textStyle, 'Buscar', Icons.search, (){
              Navigator.pushNamed(context, 'buscar');
            }),
          ]
        ),
      )
   );
  }

  Widget _boton(TextStyle _text, String _title, IconData _icono, Function data){
    return ElevatedButton(
              onPressed: data, 
              child: ListTile(
                title: Text(_title, style: _text,),
                leading: Icon(_icono, color: Colors.white,),
              ),
    );
  }
}