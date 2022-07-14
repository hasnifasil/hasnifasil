// To parse this JSON data, do
//
//     final brands = brandsFromJson(jsonString);

import 'dart:convert';

Brands brandsFromJson(String str) => Brands.fromJson(json.decode(str));

String brandsToJson(Brands data) => json.encode(data.toJson());

class Brands {
  Brands({
    required this.products,
  });

  List<Product> products;

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product(
      {required this.description,
      required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.discount_price});

  String description;
  int id;
  String image;
  String name;
  double price;
  String discount_price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      description: json["description"],
      id: json["id"],
      image: json["image"],
      name: json["name"],
      price: json["price"],
      discount_price: json["discount_price"]);

  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "image": image,
        "name": name,
        "price": price,
        "discount_price": discount_price
      };
}
