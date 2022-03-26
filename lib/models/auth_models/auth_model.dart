class AuthModel {
  bool? status;
  String? message;
  AuthData? data;


  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  AuthData.fromJson(json['data']) : null;
  }


}

class AuthData {
  String? name;
  String? email;
  String? phone;
  int? id;
  String? image;
  String? token;


  AuthData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    image = json['image'];
    token = json['token'];
  }

}

class ChangePasswordMode{
  bool? status;
  String? message;
  ChangePasswordMode.fromJson(Map<String,dynamic>json){
    status=json['status'];
    message=json['message'];
  }
}
