class Featured {
  Featured({
    required this.featuredProducts,
  });

  List<FeaturedProduct> featuredProducts;

  factory Featured.fromJson(Map<String, dynamic> json) => Featured(
        featuredProducts: List<FeaturedProduct>.from(
            json["featured_products"].map((x) => FeaturedProduct.fromJson(x))),
      );
}

class FeaturedProduct {
  FeaturedProduct(
      {required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.description});

  int id;
  String image;
  String name;
  double price;
  String description;

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) =>
      FeaturedProduct(
          id: json["id"],
          image: json["image"],
          name: json["name"],
          price: json["price"],
          description: json["description"]);
}
