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
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    print(decodedData.length);

    final producto = new Productos.fromJson(decodedData);

    print('DATOS:  ${producto.precioUnitario}');

    return producto;
  }

  Future<List<Productos>> getProductosPorNombre(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final urlHost = prefs.getString('url');
    print(id);
    final url = Uri.http(urlHost, 'verificator-app/v1/articulos/clave/$id');
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    print(decodedData.length);
    print('Data del http: $decodedData');

    final productos = new ProductosList.fromJsonList(decodedData);
    print(productos.productosList[0].nombreArticulo);

    return productos.productosList;
  }

  Future<List<Productos>> getProductosPorNombreId(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    final urlHost = prefs.getString('url');
    print(nombre);
    final url = Uri.http(urlHost, 'verificator-app/v1/articulos/clave/$nombre');
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    print(decodedData.length);
    print('Data del http: $decodedData');

    final productos = new ProductosList.fromJsonList(decodedData);
    print(productos.productosList[0].nombreArticulo);

    return productos.productosList;
  }
}
