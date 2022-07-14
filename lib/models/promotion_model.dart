import 'dart:convert';

PromotionProducts PromotionProductsFromJson(String str) =>
    PromotionProducts.fromJson(json.decode(str));

class PromotionProducts {
  PromotionProducts({
    required this.products,
  });

  List<Beauty> products;

  factory PromotionProducts.fromJson(Map<String, dynamic> json) =>
      PromotionProducts(
        products:
            List<Beauty>.from(json["products"].map((x) => Beauty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Beauty {
  Beauty(
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

  factory Beauty.fromJson(Map<String, dynamic> json) => Beauty(
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
        "discount_price": "discount_price"
      };
}
