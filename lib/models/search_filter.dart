import 'dart:convert';

SearchFilter searchFilterFromJson(String str) =>
    SearchFilter.fromJson(json.decode(str));

class SearchFilter {
  SearchFilter({
    required this.products,
  });

  List<Products> products;

  factory SearchFilter.fromJson(Map<String, dynamic> json) => SearchFilter(
        products: List<Products>.from(
            json["products"].map((x) => Products.fromJson(x))),
      );
}

class Products {
  Products(
      {required this.id,
      required this.name,
      required this.img,
      required this.price});

  int id;
  String name;
  String img;
  double price;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
      id: json["id"],
      name: json["name"],
      img: json["img"],
      price: json["price"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "price": price, "img": img};
}
