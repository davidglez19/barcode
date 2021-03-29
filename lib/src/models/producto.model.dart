import 'dart:convert';

Productos productosFromJson(String str) => Productos.fromJson(json.decode(str));

String productosToJson(Productos data) => json.encode(data.toJson());

class Productos {
  List<Productos> productos = [];

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
    for (var item in jsonList) {
      final producto = new Productos.fromJson(item);
      productos.add(producto);
    }
  }

   factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        articuloId    : json["ARTICULO_ID"],
        nombreArticulo: json["NOMBRE_ARTICULO"],
        precioUnitario: json["PRECIO_UNITARIO"],
        existencia    : json["EXISTENCIA"],
        unidadVenta   : json["UNIDAD_VENTA"],
    );

    Map<String, dynamic> toJson() => {
        "ARTICULO_ID"    : articuloId,
        "NOMBRE_ARTICULO": nombreArticulo,
        "PRECIO_UNITARIO": precioUnitario,
        "EXISTENCIA"     : existencia,
        "UNIDAD_VENTA"   : unidadVenta,
    };
}
