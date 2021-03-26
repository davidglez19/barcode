import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:barcode/src/models/producto.model.dart';

class ProductosServices extends ChangeNotifier {
  String _idCodigo;

  List<Productos> _productosList = [];

  List<Productos> get productosList {
    return this._productosList;
  }

  set productosList(List<Productos> productosApi) {
    this._productosList = productosApi;
    notifyListeners();
  }

  String get idCodigo {
    return this._idCodigo;
  }

  set idCodigo(String id) {
    this._idCodigo = id;
    notifyListeners();
  }

// http://192.168.0.26:1989/api/productos
// https://serverssc.herokuapp.com/api/productos

  String _url = 'serverssc.herokuapp.com';

  Future getProductos(String id) async {
    print(id);
    final url = Uri.https(_url, 'api/productos/$id');
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final producto = new Productos.fromJson(decodedData['productos']);
    print('DATOS:  $producto');

    return producto;
  }
}
