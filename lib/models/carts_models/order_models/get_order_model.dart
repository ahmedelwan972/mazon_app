class GetOrderModel {
  bool? status;
  GetOrderData? data;


  GetOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ?  GetOrderData.fromJson(json['data']) : null;
  }

}

class GetOrderData {
  int? currentPage;
  List<Data>? data;


  GetOrderData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

}

class Data {
  int? id;
  dynamic total;
  String? date;
  String? status;


  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
  }

}
