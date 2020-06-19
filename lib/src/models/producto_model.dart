// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str)); //Este lo retorna como Json

String productoModelToJson(ProductoModel data) => json.encode(data.toJson()); // Este lo retorna como string

class ProductoModel {
    String id;
    String titulo;
    double valor;
    bool disponible;
    String fotoUrl;

    ProductoModel({
        this.id,
        this.titulo = '',
        this.valor  = 0.0,
        this.disponible = true,
        this.fotoUrl,
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel( //Retorna una nueva instancia por eso es factory
        id         : json["id"],
        titulo     : json["titulo"],
        valor      : json["valor"],
        disponible : json["disponible"],
        fotoUrl    : json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => { // Aqui el proceso inverso toma el modelo y lo transforma a JSON
        // "id"         : id, // Para que no mande el Id al momento de actualizar
        "titulo"     : titulo,
        "valor"      : valor,
        "disponible" : disponible,
        "fotoUrl"    : fotoUrl,
    };
}



//////////////////////////////// Pagina que nos genera un modelo ////////////////////////////////////////
///https://app.quicktype.io/?share=4Ik8Upww0mN33e2CBVmq