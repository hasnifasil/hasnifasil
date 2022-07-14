class ProductVariant {
  Attributes? attributes;
  List<String>? attributesList;
  // Detail? detail;

  ProductVariant({this.attributes, this.attributesList});

  ProductVariant.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    attributesList = json['attributes_list'].cast<String>();
    //  detail =
    // json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }
}

class Attributes {
  List<Eight>? l85;
  List<Color>? color;
  List<Design>? dESIGN;
  List<FLAVOR>? fLAVOR;
  List<Flavour>? flavour;
  List<Mg>? mG;
  List<Model>? model;
  List<PackageQuantity>? packageQuantity;
  List<Power>? power;
  List<ProductPageType>? productPageType;
  List<Scent>? scent;
  List<Size>? size;
  List<Template>? tEMPLATES;
  List<Type>? type;
  List<Volume>? volume;

  List<Powe>? powe;

  Attributes(
      {this.l85,
      this.color,
      this.dESIGN,
      this.fLAVOR,
      this.flavour,
      this.mG,
      this.model,
      this.packageQuantity,
      this.power,
      this.productPageType,
      this.scent,
      this.size,
      this.tEMPLATES,
      this.type,
      this.volume,
      this.powe});

  Attributes.fromJson(Map<String, dynamic> json) {
    if (json['8.5'] != null && json['8.5'].isNotEmpty) {
      l85 = <Eight>[];
      json['8.5'].forEach((v) {
        l85!.add(new Eight.fromJson(v));
      });
    }

    if (json['Color'] != null && json['Color'].isNotEmpty) {
      color = <Color>[];
      json['Color'].forEach((v) {
        color!.add(Color.fromJson(v));
      });
    }

    if (json['Design'] != null && json['Design'].isNotEmpty) {
      dESIGN = <Design>[];
      json['DESIGN'].forEach((v) {
        dESIGN!.add(new Design.fromJson(v));
      });
    }
    if (json['FLAVOR'] != null && json['FLAVOR'].isNotEmpty) {
      fLAVOR = <FLAVOR>[];
      json['FLAVOR'].forEach((v) {
        fLAVOR!.add(new FLAVOR.fromJson(v));
      });
    }
    if (json['Flavour'] != null && json['Flavour'].isNotEmpty) {
      flavour = <Flavour>[];
      json['Flavour'].forEach((v) {
        flavour!.add(new Flavour.fromJson(v));
      });
    }
    if (json['MG'] != null && json['MG'].isNotEmpty) {
      mG = <Mg>[];
      json['MG'].forEach((v) {
        mG!.add(new Mg.fromJson(v));
      });
    }

    // if (json['Package Quantity'] != null &&
    //     json['Package Quantity'.isNotEmpty]) {
    //   packageQuantity = <PackageQuantity>[];
    //   json['Package Quantity'].forEach((v) {
    //     packageQuantity!.add(new PackageQuantity.fromJson(v));
    //   });
    // }
    if (json['Power'] != null && json['Power'].isNotEmpty) {
      power = <Power>[];
      json['Power'].forEach((v) {
        power!.add(new Power.fromJson(v));
      });
    }
    if (json['Product Page Type'] != null &&
        json['Product Page Type'].isNotEmpty) {
      productPageType = <ProductPageType>[];
      json['Product Page Type'].forEach((v) {
        productPageType!.add(new ProductPageType.fromJson(v));
      });
    }
    if (json['Scent'] != null && json['Scent'].isNotEmpty) {
      scent = <Scent>[];
      json['Scent'].forEach((v) {
        scent!.add(new Scent.fromJson(v));
      });
    }
    if (json['Size'] != null && json['Size'].isNotEmpty) {
      size = <Size>[];
      json['Size'].forEach((v) {
        size!.add(new Size.fromJson(v));
      });
    }
    if (json['TEMPLATES'] != null && json['TEMPLATES'].isNotEmpty) {
      tEMPLATES = <Template>[];
      json['TEMPLATES'].forEach((v) {
        tEMPLATES!.add(new Template.fromJson(v));
      });
    }
    if (json['Type'] != null && json['Type'].isNotEmpty) {
      type = <Type>[];
      json['Type'].forEach((v) {
        type!.add(new Type.fromJson(v));
      });
    }
    if (json['Volume'] != null && json['Volume'].isNotEmpty) {
      volume = <Volume>[];
      json['Volume'].forEach((v) {
        volume!.add(new Volume.fromJson(v));
      });
    }
    if (json['model'] != null && json['model'].isNotEmpty) {
      model = <Model>[];
      json['model'].forEach((v) {
        model!.add(new Model.fromJson(v));
      });
    }
    if (json['powe'] != null && json['powe'].isNotEmpty) {
      powe = <Powe>[];
      json['powe'].forEach((v) {
        powe!.add(new Powe.fromJson(v));
      });
    }
  }
}

class TEMPLATE {
  int? attValueId;
  String? name;

  TEMPLATE({this.attValueId, this.name});

  TEMPLATE.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class FLAVOR {
  int? attValueId;
  String? name;

  FLAVOR({this.attValueId, this.name});

  FLAVOR.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Color {
  int? attValueId;
  String? name;

  Color({this.attValueId, this.name});

  Color.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Design {
  int? attValueId;
  String? name;

  Design({this.attValueId, this.name});

  Design.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Flavour {
  int? attValueId;
  String? name;

  Flavour({this.attValueId, this.name});

  Flavour.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Power {
  int? attValueId;
  String? name;

  Power({this.attValueId, this.name});

  Power.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Size {
  int? attValueId;
  String? name;

  Size({this.attValueId, this.name});

  Size.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class ProductPageType {
  int? attValueId;
  String? name;

  ProductPageType({this.attValueId, this.name});

  ProductPageType.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Template {
  int? attValueId;
  String? name;

  Template({this.attValueId, this.name});

  Template.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class PackageQuantity {
  int? attValueId;
  String? name;

  PackageQuantity({this.attValueId, this.name});

  PackageQuantity.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Scent {
  int? attValueId;
  String? name;

  Scent({this.attValueId, this.name});

  Scent.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Volume {
  int? attValueId;
  String? name;

  Volume({this.attValueId, this.name});

  Volume.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Model {
  int? attValueId;
  String? name;

  Model({this.attValueId, this.name});

  Model.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Mg {
  int? attValueId;
  String? name;

  Mg({this.attValueId, this.name});

  Mg.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Eight {
  int? attValueId;
  String? name;

  Eight({this.attValueId, this.name});

  Eight.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Powe {
  int? attValueId;
  String? name;

  Powe({this.attValueId, this.name});

  Powe.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

class Type {
  int? attValueId;
  String? name;

  Type({this.attValueId, this.name});

  Type.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'];
    name = json['name'];
  }
}

// class Detail {
//   String? description;
//   int? id;
//   String? image;
//   String? name;
//   double? price;

//   Detail({this.description, this.id, this.image, this.name, this.price});

//   Detail.fromJson(Map<String, dynamic> json) {
//     description = json['description'];
//     id = json['id'];
//     image = json['image'];
//     name = json['name'];
//     price = json['price'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['description'] = this.description;
//     data['id'] = this.id;
//     data['image'] = this.image;
//     data['name'] = this.name;
//     data['price'] = this.price;
//     return data;
//   }

