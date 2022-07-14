import 'dart:typed_data';

class Cart {
  int? did;
  final int pid;
  final String name;

  final String image;
  final double initialprice;
  final double price;

  final int quantity;
  final String type;
  final String color;
  final String power;
  final String size;

  final String attType;
  final String model;
  final String flavour;
  final String flvr;
  final String l85;
  final String mg;
  final String colorname;
  final String powername;
  final String sizename;
  final String volumename;
  final String modelname;


  Cart(
      {required this.did,
      required this.pid,
      required this.name,
      required this.image,
      required this.initialprice,
      required this.price,
      required this.quantity,
      required this.type,
      required this.color,
      required this.power,
      required this.size,
      required this.attType,
      required this.model,
      required this.flavour,
      required this.flvr,
      required this.l85,
      required this.mg,
      required this.colorname,
      required this.powername,
      required this.sizename,
      required this.volumename,required this.modelname,
      });
  Cart.fromMap(Map<dynamic, dynamic> res)
      : did = res["did"],
        pid = res["pid"],
        name = res["name"],
        image = res["image"],
        initialprice = res["initialprice"],
        price = res["price"],
        quantity = res["quantity"],
        type = res["type"],
        color = res["color"],
        power = res["power"],
        size = res["size"],
        attType = res["attType"],
        model = res["model"],
        flavour = res["flavour"],
        flvr = res["flvr"],
        l85 = res["l85"],
        mg = res["mg"],
        colorname=res["colorname"],powername=res["powername"],
        sizename=res["sizename"],volumename=res["volumename"],modelname=res["modelname"];
  Map<String, Object?> toMap() {
    return {
      'did': did,
      'pid': pid,
      'name': name,
      'image': image,
      'initialprice': initialprice,
      'price': price,
      'quantity': quantity,
      'type': type,
      'color': color,
      'power': power,
      'size':size,
      'attType':attType,
      'model':model,
      'flavour':flavour,
      'flvr':flvr,
      'l85':l85,
      'mg':mg,
      'colorname':colorname,
      'powername':powername,
      'sizename':sizename,
      'volumename':volumename,
      'modelname':modelname
    };
  }
}
