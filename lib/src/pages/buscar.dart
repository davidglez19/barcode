import 'package:barcode/src/services/produto.serivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuscarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final productosService = Provider.of<ProductosServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar por nombre'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  productosService.idCodigo = value;
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Clave'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (String value) {
                  print(value);
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Nombre'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'listar');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.search_sharp,
                      color: Color(0xffffffff),
                    ),
                    title: Text(
                      'Buscar',
                      style: TextStyle(color: Color(0xffffffff)),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
