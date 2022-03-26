class OrderDetailsModel {
  bool? status;
  OrderDetailsData? data;


  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new OrderDetailsData.fromJson(json['data']) : null;
  }

}

class OrderDetailsData {
  int? id;
  dynamic cost;
  dynamic discount;
  dynamic vat;
  dynamic total;
  String? promoCode;
  String? paymentMethod;
  String? date;
  String? status;
  Address? address;
  List<Products>? products;



  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    discount = json['discount'];
    vat = json['vat'];
    total = json['total'];
    promoCode = json['promo_code'];
    paymentMethod = json['payment_method'];
    date = json['date'];
    status = json['status'];
    address =
    json['address'] != null ?  Address.fromJson(json['address']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

}

class Address {
  String? city;
  String? region;


  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    region = json['region'];
  }

}

class Products {
  int? id;
  int? quantity;
  dynamic price;
  String? name;
  String? image;


  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
  }

}
