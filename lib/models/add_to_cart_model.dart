// class CartModel {
//   String? jsonrpc;
//   Null? id;
//   Result? result;

//   CartModel({this.jsonrpc, this.id, this.result});

//   CartModel.fromJson(Map<String, dynamic> json) {
//     jsonrpc = json['jsonrpc'];
//     id = json['id'];
//     result =
//         json['result'] != null ? new Result.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['jsonrpc'] = this.jsonrpc;
//     data['id'] = this.id;
//     if (this.result != null) {
//       data['result'] = this.result!.toJson();
//     }
//     return data;
//   }
// }

// class Result {
//   int? status;
//   String? message;
//   String? name;
//   int? saleId;
//   List<Details>? details;
//   double? totalAmount;

//   Result(
//       {this.status,
//       this.message,
//       this.name,
//       this.saleId,
//       this.details,
//       this.totalAmount});

//   Result.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     name = json['name'];
//     saleId = json['sale_id'];
//     if (json['details'] != null) {
//       details = <Details>[];
//       json['details'].forEach((v) {
//         details!.add(new Details.fromJson(v));
//       });
//     }
//     totalAmount = json['total_amount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['name'] = this.name;
//     data['sale_id'] = this.saleId;
//     if (this.details != null) {
//       data['details'] = this.details!.map((v) => v.toJson()).toList();
//     }
//     data['total_amount'] = this.totalAmount;
//     return data;
//   }
// }

// class Details {
//   int? productId;
//   String? name;
//   double? price;
//   double? qty;
//   double? discPerc;
//   double? lineTotal;
//   double? discountedUnitPrice;
//   int? lineId;
//   int? templateId;
//   List<int>? attValueId;
//   String? image;

//   Details(
//       {this.productId,
//       this.name,
//       this.price,
//       this.qty,
//       this.discPerc,
//       this.lineTotal,
//       this.discountedUnitPrice,
//       this.lineId,
//       this.templateId,
//       this.attValueId,
//       this.image});

//   Details.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     name = json['name'];
//     price = json['price'];
//     qty = json['qty'];
//     discPerc = json['disc_perc'];
//     lineTotal = json['line_total'];
//     discountedUnitPrice = json['discounted_unit_price'];
//     lineId = json['line_id'];
//     templateId = json['template_id'];
//     attValueId = json['att_value_id'].cast<int>();
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['name'] = this.name;
//     data['price'] = this.price;
//     data['qty'] = this.qty;
//     data['disc_perc'] = this.discPerc;
//     data['line_total'] = this.lineTotal;
//     data['discounted_unit_price'] = this.discountedUnitPrice;
//     data['line_id'] = this.lineId;
//     data['template_id'] = this.templateId;
//     data['att_value_id'] = this.attValueId;
//     data['image'] = this.image;
//     return data;
//   }
// }
