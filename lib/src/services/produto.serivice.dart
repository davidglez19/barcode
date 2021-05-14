import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_client_helper/http_client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barcode/src/models/producto.model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ProductosServices extends ChangeNotifier {
  CancellationToken cancellationToken;

  String _idCodigo;

  String get idCodigo {
    return this._idCodigo;
  }

  set idCodigo(String id) {
    this._idCodigo = id;
    notifyListeners();
  }

  String _idNombre;

  String get idNombre {
    return this._idNombre;
  }

  set idNombre(String nombre) {
    this._idNombre = nombre;
    notifyListeners();
  }

// http://192.168.0.26:1989/api/productos
// https://serverssc.herokuapp.com/api/productos
//http://ursoft.ddns.net/verificador/public/articulos/00-120
//http://ursoft.ddns.net/verificator-app/v1/articulos/123

  // String _url = pref.;
/*
  checkConnection() async {
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(seconds: 30));
    await listener.cancel();
  }*/
  Future getProductos(String id) async {
    // cancellationToken.cancel();
    // print('CANCELARTOKEN => ${cancellationToken}');

    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(milliseconds: 800));
    await listener.cancel();

    DataConnectionStatus status =
        await DataConnectionChecker().connectionStatus;

    final prefs = await SharedPreferences.getInstance();
    final urlHost = prefs.getString('url');

    // final urlH = 'ursoft.ddns.net';

    print(id);
    print(urlHost);
    if (status == DataConnectionStatus.connected) {
      print('Conexion exitosa');
      final url = Uri.http(urlHost, 'verificator-app/v1/articulos/$id');

      try {
        cancellationToken = CancellationToken();
        print(cancellationToken?.isCanceled);
        return await HttpClientHelper.get(url,
                cancelToken: cancellationToken,
                timeRetry: Duration(milliseconds: 800),
                retries: 3,
                timeLimit: Duration(seconds: 6))
            .then((resp) {
          if (resp != null) {
            print('CANCELADO');
            if (id.length > 20 || id.contains('/') || resp.statusCode == 404) {
              return Productos.fromJson({
                "ARTICULO_ID": null,
                "NOMBRE_ARTICULO": 'ERROR EN EL HOST',
                "PRECIO_UNITARIO": null,
                "EXISTENCIA": null,
                "UNIDAD_VENTA": null,
                "CLAVE": null,
              });
            }
            print('STATUS => ${resp.statusCode}');
            final decodedData = json.decode(resp.body);
            print('DECODEDATA => $decodedData');
            print(decodedData.length);

            final producto = new Productos.fromJson(decodedData);

            print('DATOS:  ${producto.precioUnitario}');
            return producto;
          } else {
            print('RESP NULL');
            cancellationToken.cancel();
            print(cancellationToken.isCanceled);
            return peticionError();
          }
        });
      } on TimeoutException catch (_) {
        // cancel();
        return peticionError();
      } on OperationCanceledError catch (_) {
        // cancel();
        return peticionError();
      } on SocketException catch (_) {
        // cancel();
        return peticionError();
      } catch (_) {
        cancel();
        return peticionError();
      }
    } else {
      return peticionError();
    }
  }

  void cancel() {
    print('Entro');
    cancellationToken?.cancel();
  }

/*
  Future getProductos(String id) async {
    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(milliseconds: 800));
    await listener.cancel();

    DataConnectionStatus status =
        await DataConnectionChecker().connectionStatus;

    final prefs = await SharedPreferences.getInstance();
    final urlHost = prefs.getString('url');

    // final urlH = 'ursoft.ddns.net';

    print(id);
    print(urlHost);
    if (status == DataConnectionStatus.connected) {
      print('Conexion exitosa');
      final url = Uri.http(urlHost, 'verificator-app/v1/articulos/$id');
      try {
        final resp = await http.get(url).timeout(const Duration(seconds: 8));
        if (id.length > 20 || id.contains('/') || resp.statusCode == 404) {
          return Productos.fromJson({
            "ARTICULO_ID": null,
            "NOMBRE_ARTICULO": null,
            "PRECIO_UNITARIO": null,
            "EXISTENCIA": null,
            "UNIDAD_VENTA": null,
            "CLAVE": null,
          });
        }
        print('STATUS => ${resp.statusCode}');
        final decodedData = json.decode(resp.body);
        print('DECODEDATA => $decodedData');
        print(decodedData.length);

        final producto = new Productos.fromJson(decodedData);

        print('DATOS:  ${producto.precioUnitario}');
        return producto;
      } on TimeoutException catch (_) {
        return peticionError();
      } on SocketException {
        print('Error el Socket');
        return peticionError();
      } on HttpException {
        return peticionError();
      } on FormatException {
        return peticionError();
      }
    } else {
      return peticionError();
    }
  }

*/
  Future<List<Productos>> getProductosPorNombre(String id) async {
    DataConnectionStatus status =
        await DataConnectionChecker().connectionStatus;

    if (status == DataConnectionStatus.connected) {
      final prefs = await SharedPreferences.getInstance();
      final urlHost = prefs.getString('url');
      print(id);
      final url = Uri.http(urlHost, 'verificator-app/v1/articulos/clave/$id');
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        return [];
      }
      final decodedData = json.decode(resp.body);
      // print(decodedData);

      print('Data del http --: $decodedData');
      if (decodedData.length > 0) {
        final productos = new ProductosList.fromJsonList(decodedData);
        print('Lista resp : ${productos.productosList}');
        return productos.productosList;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

// http://ursoft.ddns.net/verificator-app/v1/articulos/nombre/bomba
  Future<List<Productos>> getProductosPorNombreId(String nombre) async {
    DataConnectionStatus status =
        await DataConnectionChecker().connectionStatus;

    if (status == DataConnectionStatus.connected) {
      final prefs = await SharedPreferences.getInstance();
      final urlHost = prefs.getString('url');
      print(nombre);
      final url =
          Uri.http(urlHost, 'verificator-app/v1/articulos/nombre/$nombre');
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        return [];
      }

      print('Valores de la resupuesta ${resp.body}');

      final decodedData = json.decode(resp.body);
      print(decodedData.length);
      print('Data del http: $decodedData');

      if (decodedData.length > 0) {
        final productos = new ProductosList.fromJsonList(decodedData);
        print(productos.productosList[0].nombreArticulo);

        return productos.productosList;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  peticionError() {
    return Productos.fromJson({
      "ARTICULO_ID": null,
      "NOMBRE_ARTICULO": 'ERROR EN EL HOST',
      "PRECIO_UNITARIO": null,
      "EXISTENCIA": null,
      "UNIDAD_VENTA": null,
      "CLAVE": null,
    });
  }
}
