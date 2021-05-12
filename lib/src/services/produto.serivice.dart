import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barcode/src/models/producto.model.dart';

class ProductosServices extends ChangeNotifier {
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

  Future getProductos(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final urlHost = prefs.getString('url');

    // final urlH = 'ursoft.ddns.net';

    print(id);
    print(urlHost);
    final url = Uri.http(urlHost, 'verificator-app/v1/articulos/$id');
    try {
      final resp = await http.get(url);
      if (id.length > 20 || id.contains('/')) {
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
    } catch (err) {
      return;
    }
  }

  Future<List<Productos>> getProductosPorNombre(String id) async {
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
  }

// http://ursoft.ddns.net/verificator-app/v1/articulos/nombre/bomba
  Future<List<Productos>> getProductosPorNombreId(String nombre) async {
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
  }
}
