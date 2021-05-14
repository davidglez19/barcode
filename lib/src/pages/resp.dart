import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import 'package:barcode/src/services/produto.serivice.dart';

class RespuestaPage extends StatefulWidget {
  @override
  _RespuestaPageState createState() => _RespuestaPageState();
}

class _RespuestaPageState extends State<RespuestaPage> {
  Future scannerCodigo(BuildContext context) async {
    DataConnectionStatus status = await checkConnection();

    if (status == DataConnectionStatus.connected) {
      final productosService =
          Provider.of<ProductosServices>(context, listen: false);
      String scannerCode = await FlutterBarcodeScanner.scanBarcode(
          '#2D96F5', 'Cancelar', false, ScanMode.BARCODE);
      if (scannerCode == '-1') {
        return Navigator.popAndPushNamed(context, 'home');
        // return Navigator.pushNamed(context, 'respuesta');
      } else {
        productosService.idCodigo = scannerCode;
        return Navigator.popAndPushNamed(context, 'respuesta');
      }
    } else {
      _sinConexion(context);
    }
  }

  cambiarPagina() {
    Future.delayed(Duration(milliseconds: 1500), () {
      scannerCodigo(context);
      // Navigator.popAndPushNamed(context, 'home');
    });
  }

  cambiarPagina2() {
    Future.delayed(Duration(milliseconds: 1500), () {
      // scannerCodigo(context);
      // Navigator.popAndPushNamed(context, 'buscar');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('buscar', ModalRoute.withName('home'));
    });
  }

  cambiarError() {
    Future.delayed(Duration(milliseconds: 800), () {
      scannerCodigo(context);
      // Navigator.popAndPushNamed(context, 'home');
    });
  }

  @override
  void dispose() {
    DataConnectionChecker().onStatusChange.listen((event) {}).cancel();
    super.dispose();
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
          print('Cicular ===> ${snapshot.hasData}');
          print('Data ===> ${snapshot.data}');
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data?.precioUnitario != null) {
          print('Datos Codigo${snapshot.hasData}');
          // productosService.productosList.add(snapshot.data);

          print('VALORES PASANDO: $args');

          if (args == false || args == null) {
            cambiarPagina();
          } else {
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
          if (args == false || args == null) {
            cambiarError();
          } else {
            cambiarPagina2();
          }
          print('Error: ${snapshot.hasData}');
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
                (snapshot.data.nombreArticulo == null)
                    ? 'Producto no encontrado'
                    : '${snapshot.data.nombreArticulo}',
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
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          'home', ModalRoute.withName('home')),
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
  // await Future.delayed(Duration(milliseconds: 3000));

  // await listener.cancel();

  return await DataConnectionChecker().connectionStatus;
}
