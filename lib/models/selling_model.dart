class Selling {
  Selling({
    required this.mostSelling,
  });

  List<Datum> mostSelling;

  factory Selling.fromJson(Map<String, dynamic> json) => Selling(
        mostSelling: List<Datum>.from(
            json["most_selling"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  });

  int id;
  String image;
  String name;
  String description;
  double price;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"],
      image: json["image"],
      name: json["name"],
      price: json["price"],
      description: json["description"]);
}
