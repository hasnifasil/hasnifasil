class ProductClass {
  ProductClass({
    required this.products,
  });

  List<Products> products;

  factory ProductClass.fromJson(Map<String, dynamic> json) => ProductClass(
        products: List<Products>.from(
            json["products"].map((x) => Products.fromJson(x))),
      );
}

class Products {
  Products(
      {required this.description,
      required this.id,
    required this.image,
      required this.name,
      required this.price,
      required this.discount_price});
  String? description;
  int id;
  String image;
  String name;
  double price;
  String discount_price;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
      description: json["description"],
      id: json["id"],
      image: json["image"],
      name: json["name"],
      price: json["price"],
      discount_price: json["discount_price"]);
}
