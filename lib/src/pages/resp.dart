import 'package:flutter/material.dart';

import 'package:barcode/src/services/produto.serivice.dart';
import 'package:provider/provider.dart';

class RespuestaPage extends StatelessWidget {
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
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 2);
    final txtDetalles = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        letterSpacing: 2,
        color: Colors.teal);

    final productos = new ProductosServices();

    final productosService = Provider.of<ProductosServices>(context);
    print('La resp: ${productosService.idCodigo}');
    return FutureBuilder(
      future: productos.getProductos(productosService.idCodigo),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // productosService.productosList.add(snapshot.data);
          print(snapshot.data);
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
                        colors: [Color(0xFF0ac3f4), Color(0xff067592)])),
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
                height: size.height * 0.45,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color(0xFFF2F0F4),
                      blurRadius: 1,
                      offset: Offset(1, 5))
                ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descripción:',
                          style: txtDetalles,
                        ),
                        Text(
                          '${(snapshot.data.descripcion).toString().toUpperCase()}',
                          style: txtResult,
                        ),
                        Text(
                          'Grupo:',
                          style: txtDetalles,
                        ),
                        Text(
                          '${(snapshot.data.grupo).toString().toUpperCase()}',
                          style: txtResult,
                        ),
                        Text(
                          'Precio:',
                          style: txtDetalles,
                        ),
                        Text(
                          '\$${(snapshot.data.precio).toString()}',
                          style: txtResult,
                        ),
                        Text(
                          'Existencias:',
                          style: txtDetalles,
                        ),
                        Text(
                          '${(snapshot.data.existencias).toString().toUpperCase()}',
                          style: txtResult,
                        ),
                      ]),
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
