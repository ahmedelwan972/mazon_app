class NotificationModel {
  bool? status;
  NotificationData? data;


  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ?  NotificationData.fromJson(json['data']) : null;
  }

}

class NotificationData {
  int? currentPage;
  List<DataNotification>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;



  NotificationData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <DataNotification>[];
      json['data'].forEach((v) {
        data!.add( DataNotification.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

}

class DataNotification {
  int? id;
  String? title;
  String? message;

  DataNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
  }

}
