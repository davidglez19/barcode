// import 'package:barcode/src/models/producto.model.dart';
import 'package:barcode/src/models/producto.model.dart';
import 'package:barcode/src/services/produto.serivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class ListaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    salirNoFound() {
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pop(context, 'buscar');
      });
    }

    final productosService = new ProductosServices();
    // productosService.getProductosPorNombre('00-10');
    final producService = Provider.of<ProductosServices>(context);

    final Map args = ModalRoute.of(context).settings.arguments as Map;
    print("ARGUMENTOS: ${args['activo']}");

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de artículos'),
      ),
      body: FutureBuilder(
        future: (args['activo'])
            ? productosService.getProductosPorNombre(producService.idCodigo)
            : productosService.getProductosPorNombreId(producService.idCodigo),
        builder:
            (BuildContext context, AsyncSnapshot<List<Productos>> snapshot) {
          if (!snapshot.hasData) {
            print('Listar -Data ${snapshot.hasData}');

            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            print('Listar -Dotos :=> ${snapshot.hasData}');
            print('Listar -data :=> ${snapshot.data}');
            return ListView(
              children: snapshot.data.map((Productos producto) {
                return ListTile(
                  title: Text(producto.nombreArticulo),
                  onTap: () {
                    producService.idCodigo = '${producto.clave}';
                    print('Clave: ${producto.clave}');
                    bool valor = true;
                    // Navigator.popAndPushNamed(context, 'respuesta', arguments: valor);
                    Navigator.of(context)
                        .pushReplacementNamed('respuesta', arguments: valor);
                  },
                );
              }).toList(),
            );
          } else {
            salirNoFound();
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.8,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.10),
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
      ),
    );
  }
}
