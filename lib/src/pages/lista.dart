// import 'package:barcode/src/models/producto.model.dart';
import 'package:barcode/src/models/producto.model.dart';
import 'package:barcode/src/services/produto.serivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class ListaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosService = new ProductosServices();
    // productosService.getProductosPorNombre('00-10');
    final producService = Provider.of<ProductosServices>(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de artículos'),
      ),
      body: 
      FutureBuilder(
        future:
            productosService.getProductosPorNombre(producService.idCodigo),
        builder: (BuildContext context, AsyncSnapshot<List<Productos>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data
                  .map(
                    (Productos producto) {
                      double precio = double.parse(producto.precioUnitario);
                      return ListTile(
                      title: Text(producto.nombreArticulo),
                      subtitle: Text('\$${precio.toStringAsFixed(2)}'),
                      onTap: (){
                        Navigator.popAndPushNamed(context, 'respuesta');
                        producService.idCodigo = '00-040';
                      },
                    );
                    } 
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
