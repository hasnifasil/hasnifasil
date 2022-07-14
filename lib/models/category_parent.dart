// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.parentCategories,
  });

  List<ParentCategory> parentCategories;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        parentCategories: List<ParentCategory>.from(
            json["parent_categories"].map((x) => ParentCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parent_categories":
            List<dynamic>.from(parentCategories.map((x) => x.toJson())),
      };
}

class ParentCategory {
  ParentCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory ParentCategory.fromJson(Map<String, dynamic> json) => ParentCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};
}
