// To parse this JSON data, do
//
//     final userAddress = userAddressFromJson(jsonString);

import 'dart:convert';
 
UserAddress userAddressFromJson(String str) =>
    UserAddress.fromJson(json.decode(str));

String userAddressToJson(UserAddress data) => json.encode(data.toJson());

class UserAddress {
  UserAddress({
    required this.data,
  });

  List<Adress> data;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        data: List<Adress>.from(json["data"].map((x) => Adress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Adress {
  Adress({
    
    required this.building,
    required this.city,
    required this.floorNumber,
    required this.mobile,
    required this.name,
    required this.street,
    required this.streetNumber,
    required this.zone,
    required this.id
  });

  String building;
  String city;
  String floorNumber;
  String mobile;
  String name;
  String street;
  String streetNumber;
  String zone;
  int id;

  factory Adress.fromJson(Map<String, dynamic> json) => Adress(
        building: json["building"],
        city: json["city"],
        floorNumber: json["floor_number"],
        mobile: json["mobile"],
        name: json["name"],
        street: json["street"],
        streetNumber: json["street_number"],
        zone: json["zone"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
   
        "building": building,
        "city": city,
        "floor_number": floorNumber,
        "mobile": mobile,
        "name": name,
        "street": street,
        "street_number": streetNumber,
        "zone": zone,
        "id":id
      };
}
