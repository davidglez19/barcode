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
//http://ursoft.ddns.net/verificador/public/articulos/00-120

  String _url = 'ursoft.ddns.net';

  Future getProductos(String id) async {
    print(id);
    final url = Uri.http(_url, 'verificador/public/articulos/$id');
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    print(decodedData.length);
    
    final producto = new Productos.fromJson(decodedData);
    
    print('DATOS:  ${producto.precioUnitario}');
    
    return producto;
  }
}
