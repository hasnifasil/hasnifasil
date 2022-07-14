class AllOrderModel {
  List<Data>? data;

  AllOrderModel({this.data});

  AllOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? building;
  String? city;
  String? country;
  String? dateOrder;
  String? mobile;
  String? order;
  double? orderTotal;
  String? status;
  String? street;
  String? streetNumber;
  String? zone;

  Data(
      {this.building,
      this.city,
      this.country,
      this.dateOrder,
      this.mobile,
      this.order,
      this.orderTotal,
      this.status,
      this.street,
      this.streetNumber,
      this.zone});

  Data.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    city = json['city'];
    country = json['country'];
    dateOrder = json['date_order'];
    mobile = json['mobile'];
    order = json['order'];
    orderTotal = json['order_total'];
    status = json['status'];
    street = json['street'];
    streetNumber = json['street_number'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['city'] = this.city;
    data['country'] = this.country;
    data['date_order'] = this.dateOrder;
    data['mobile'] = this.mobile;
    data['order'] = this.order;
    data['order_total'] = this.orderTotal;
    data['status'] = this.status;
    data['street'] = this.street;
    data['street_number'] = this.streetNumber;
    data['zone'] = this.zone;
    return data;
  }
}
