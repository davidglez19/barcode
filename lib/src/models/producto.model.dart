import 'dart:convert';

import 'package:flutter/material.dart';

Productos productosFromJson(String str) => Productos.fromJson(json.decode(str));

String productosToJson(Productos data) => json.encode(data.toJson());

class Productos extends ChangeNotifier {
  List<Productos> productosList = [];

  Productos({
    this.articuloId,
    this.nombreArticulo,
    this.precioUnitario,
    this.existencia,
    this.unidadVenta,
  });

  int articuloId;
  String nombreArticulo;
  String precioUnitario;
  String existencia;
  String unidadVenta;

  Productos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    print('Model: ${jsonList[1]}');
    print('Lenght: ${jsonList.length}');

    for (int i = 0; i < jsonList.length; i++) {
      final producto = new Productos.fromJson(jsonList[i]);
      print(producto.nombreArticulo);
      this.productosList.add(producto);
    }
    print('Listado completo ${this.productosList[5].nombreArticulo}');
  }

  factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        articuloId: json["ARTICULO_ID"],
        nombreArticulo: json["NOMBRE_ARTICULO"],
        precioUnitario: json["PRECIO_UNITARIO"],
        existencia: json["EXISTENCIA"],
        unidadVenta: json["UNIDAD_VENTA"],
      );

  Map<String, dynamic> toJson() => {
        "ARTICULO_ID": articuloId,
        "NOMBRE_ARTICULO": nombreArticulo,
        "PRECIO_UNITARIO": precioUnitario,
        "EXISTENCIA": existencia,
        "UNIDAD_VENTA": unidadVenta,
      };
}
