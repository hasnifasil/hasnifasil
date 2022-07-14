// To parse this JSON data, do
//
//     final mainBanners = mainBannersFromJson(jsonString);

import 'dart:convert';

MainBanners mainBannersFromJson(String str) =>
    MainBanners.fromJson(json.decode(str));

String mainBannersToJson(MainBanners data) => json.encode(data.toJson());

class MainBanners {
  MainBanners({
    required this.banners,
  });

  List<Banners> banners;

  factory MainBanners.fromJson(Map<String, dynamic> json) => MainBanners(
        banners:
            List<Banners>.from(json["banners"].map((x) => Banners.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
      };
}

class Banners {
  Banners({
    required this.id,
    required this.image,
    required this.name,
  });

  int id;
  String image;
  String name;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
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
