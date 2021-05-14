import 'package:barcode/src/services/produto.serivice.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
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
                  onPressed: () async {
                    // Navigator.pushNamed(context, 'listar');
                    DataConnectionStatus status = await checkConnection();
                    print(status);
                    if (status == DataConnectionStatus.connected) {
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
                    } else {
                      _sinConexion(context);
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
  // await Future.delayed(Duration(milliseconds: 1000));
  // await listener.cancel();

  return await DataConnectionChecker().connectionStatus;
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
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: Color(0xffff0011)),
                  ))
            ]),
          ),
        );
      });
}
