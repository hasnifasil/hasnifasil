class AllCartItems {
  List<Detail>? details;
  String? message;
  String? name;
  int? saleId;
  int? status;
  double? totalAmount;

  AllCartItems(
      {this.details,
      this.message,
      this.name,
      this.saleId,
      this.status,
      this.totalAmount});

  AllCartItems.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Detail>[];
      json['details'].forEach((v) {
        details!.add(new Detail.fromJson(v));
      });
    }
    message = json['message'];
    name = json['name'];
    saleId = json['sale_id'];
    status = json['status'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['name'] = this.name;
    data['sale_id'] = this.saleId;
    data['status'] = this.status;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class Detail {
  List<String>? attValueId;
  double? discPerc;
  double? discountedUnitPrice;
int? lineId;
  double? lineTotal;
  String? name;
  double? price;
  int? productId;
  double? qty;
  int? templateId;
  String?image;

  Detail(
      {this.attValueId,
      this.discPerc,
      this.discountedUnitPrice,
      this.lineId,
      this.lineTotal,
      this.name,
      this.price,
      this.productId,
      this.qty,
      this.templateId,
      this.image});

  Detail.fromJson(Map<String, dynamic> json) {
    attValueId = json['att_value_id'].cast<String>();
    discPerc = json['disc_perc'];
    discountedUnitPrice = json['discounted_unit_price'];
    lineId = json['line_id'];
    lineTotal = json['line_total'];
    name = json['name'];
    price = json['price'];
    productId = json['product_id'];
    qty = json['qty'];
    templateId = json['template_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['att_value_id'] = this.attValueId;
    data['disc_perc'] = this.discPerc;
    data['discounted_unit_price'] = this.discountedUnitPrice;
    data['line_id'] = this.lineId;
    data['line_total'] = this.lineTotal;
    data['name'] = this.name;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['qty'] = this.qty;
    data['template_id'] = this.templateId;
     data['image'] = this.image;
    return data;
  }
}
  