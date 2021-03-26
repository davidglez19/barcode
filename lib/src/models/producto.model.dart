import 'dart:convert';
import 'package:meta/meta.dart';

Productos productosFromJson(String str) => Productos.fromJson(json.decode(str));
String productosToJson(Productos data) => json.encode(data.toJson());

class Productos {
  List<Productos> productos = [];

  Productos({
    @required this.id,
    this.descripcion,
    this.grupo,
    this.precio,
    this.existencias,
  });

  String id;
  String descripcion;
  String grupo;
  double precio;
  int existencias;

  Productos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final producto = new Productos.fromJson(item);
      productos.add(producto);
    }
  }

  factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        id: json["id"],
        descripcion: json["descripcion"],
        grupo: json["grupo"],
        precio: json["precio"].toDouble(),
        existencias: json["existencias"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "grupo": grupo,
        "precio": precio,
        "existencias": existencias,
      };
}
