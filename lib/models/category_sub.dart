class SCategory {
  List<SubCategories>? subCategories;

  SCategory({this.subCategories});

  SCategory.fromJson(Map<String, dynamic> json) {
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int? id;
  String? name;
  bool? subCategory;
  String? image;
  List<SubSubCategories>? subSubCategories;

  SubCategories({this.id, this.name, this.subCategory, this.subSubCategories});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subCategory = json['sub_category'];
    if (json['sub_sub_categories'] != null) {
      subSubCategories = <SubSubCategories>[];
      json['sub_sub_categories'].forEach((v) {
        subSubCategories!.add(new SubSubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['sub_category'] = this.subCategory;
    if (this.subSubCategories != null) {
      data['sub_sub_categories'] =
          this.subSubCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSubCategories {
  int? id;
  String? name;
  String? image;
  bool? subCategory;

  SubSubCategories({this.id, this.name, this.subCategory});

  SubSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subCategory = json['sub_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['sub_category'] = this.subCategory;
    return data;
  }
}
