import 'package:barcode/src/services/produto.serivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuscarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _bucarPorClave = TextEditingController();
    TextEditingController _bucarPornombre = TextEditingController();
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
                controller: _bucarPorClave,
                keyboardType: TextInputType.text,
                // onChanged: (String value) {
                //   productosService.idCodigo = value;
                // },
                decoration: InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Clave'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextField(
                controller: _bucarPornombre,
                keyboardType: TextInputType.text,
                // onChanged: (String value) {
                //   productosService.idNombre = value;

                //   print(_bucarPornombre.text);
                // },
                decoration: InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Nombre'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, 'listar');

                    if (_bucarPorClave.text.length > 0 &&
                        _bucarPornombre.text.isEmpty) {
                      productosService.idCodigo = _bucarPorClave.text;
                      Navigator.pushNamed(context, 'listar', arguments: {
                        "codigo": productosService.idCodigo,
                        "activo": true
                      });
                    } else if (_bucarPornombre.text.length > 0 &&
                        _bucarPorClave.text.isEmpty) {
                      productosService.idCodigo = _bucarPornombre.text;
                      Navigator.pushNamed(context, 'listar', arguments: {
                        "codigo": productosService.idCodigo,
                        "activo": false
                      });
                    }
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
