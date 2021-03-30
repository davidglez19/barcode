import 'package:barcode/src/models/producto.model.dart';
import 'package:barcode/src/services/produto.serivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosService = Provider.of<ProductosServices>(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de artículos'),
      ),
      body: FutureBuilder(
        future:
            productosService.getProductosPorNombre(productosService.idCodigo),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data
                  .map(
                    (dynamic producto) => ListTile(
                      title: Text(producto.nombreArticulo),
                    ),
                  )
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
