// To parse this JSON data, do
//
//     final mainpromotion = mainpromotionFromJson(jsonString);

import 'dart:convert';

Mainpromotion mainpromotionFromJson(String str) =>
    Mainpromotion.fromJson(json.decode(str));

String mainpromotionToJson(Mainpromotion data) => json.encode(data.toJson());

class Mainpromotion {
  Mainpromotion({
    required this.promotions,
  });

  List<Promotions> promotions;

  factory Mainpromotion.fromJson(Map<String, dynamic> json) => Mainpromotion(
        promotions: List<Promotions>.from(
            json["promotions"].map((x) => Promotions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotions": List<dynamic>.from(promotions.map((x) => x.toJson())),
      };
}

class Promotions {
  Promotions({
    required this.id,
    required this.image,
    required this.name,
  });

  int id;
  String image;
  String name;

  factory Promotions.fromJson(Map<String, dynamic> json) => Promotions(
        id: json["id"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
      };
}
