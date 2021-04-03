import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import 'package:barcode/src/services/produto.serivice.dart';

class RespuestaPage extends StatefulWidget {
  @override
  _RespuestaPageState createState() => _RespuestaPageState();
}

class _RespuestaPageState extends State<RespuestaPage> {
  
  Future scannerCodigo(BuildContext context) async{
    final productosService = Provider.of<ProductosServices>(context,listen: false);
    String scannerCode = await FlutterBarcodeScanner.scanBarcode(
                  '#2D96F5', 'Cancelar', false, ScanMode.BARCODE);
                  if (scannerCode == '-1') {
                    return Navigator.popAndPushNamed(context, 'home');
                    // return Navigator.pushNamed(context, 'respuesta');
                  }else{
                  productosService.idCodigo = scannerCode;
                    return Navigator.popAndPushNamed(context, 'respuesta');
                  }
  }

  cambiarPagina() {
    Future.delayed(Duration(milliseconds: 3500), () {
      scannerCodigo(context);
      // Navigator.popAndPushNamed(context, 'home');
    });
  }

   cambiarPagina2() {
    Future.delayed(Duration(milliseconds: 3500), () {
      // scannerCodigo(context);
      // Navigator.popAndPushNamed(context, 'buscar');
      Navigator.of(context).pushNamedAndRemoveUntil('buscar', ModalRoute.withName('home'));
    });
  }

  cambiarError() {
    Future.delayed(Duration(milliseconds: 1500), () {
      scannerCodigo(context);
      // Navigator.popAndPushNamed(context, 'home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador'),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(child: _productos(size, context)),
      ),
    );
  }

  Widget _productos(Size size, BuildContext context) {
    final txtResult =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2);
    final txtDetalles = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 45,
        letterSpacing: 2,
        color: Colors.teal);

    final productos = new ProductosServices();

    final productosService = Provider.of<ProductosServices>(context);
    // productos.getProductos(productosService.idCodigo);
    print('La resp: ${productosService.idCodigo}');
    return FutureBuilder(
      future: productos.getProductos(productosService.idCodigo),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final args = ModalRoute.of(context).settings.arguments;
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data.precioUnitario != null) {
          // productosService.productosList.add(snapshot.data);

          print('VALORES PASANDO: $args');

          if(args == false || args == null){
            cambiarPagina(); 
          }else{
            cambiarPagina2();
            
          }
              

          

          double precio = double.parse(snapshot.data.precioUnitario);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.8,
                height: 50,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0ac3f4), Color(0xff067592)]),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFF2F0F4),
                          blurRadius: 5,
                          offset: Offset(1, 5)),
                    ]),
                child: Text(
                  'Producto',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: size.width * 0.8,
                height: size.height * 0.65,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color(0xFFF2F0F4),
                      blurRadius: 1,
                      offset: Offset(1, 5))
                ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${(precio).toStringAsFixed(2)}',
                          style: txtDetalles,
                        ),
                        Text(
                          '${(snapshot.data.nombreArticulo).toString().toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: txtResult,
                        ),
                        Text(
                          'Existencias: ${(snapshot.data.existencia).toString().toUpperCase()} ${snapshot.data.unidadVenta}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ]),
                ),
              ),
            ],
          );
        } else {
          cambiarError();
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: size.width * 0.8,
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.bottomCenter,
                      colors: [Colors.red, Colors.redAccent])),
              child: Text(
                'Producto no encontrado',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ]);
        }
      },
    );
  }
}
