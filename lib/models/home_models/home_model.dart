class HomeModel {
  bool? status;
  HomeData? data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ?  HomeData.fromJson(json['data']) : null;
  }

}

class HomeData {
  List<Banners>? banners;
  List<Products>? products;
  String? ad;

  HomeData({this.banners, this.products, this.ad});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add( Banners.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add( Products.fromJson(v));
      });
    }
    ad = json['ad'];
  }

}

class Banners {
  int? id;
  String? image;

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

}

class Products {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;


  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

}


class CategoriesModel{

  CategoriesData? data;

  CategoriesModel.fromJson(Map<String,dynamic>json){

    data = json['data'] != null ?  CategoriesData.fromJson(json['data']) : null;

  }
}

class CategoriesData{

  int? current_page;
  List<CategoriesListData>? data;

  CategoriesData.fromJson(Map<String,dynamic>json){
    current_page = json['current_page'];
    if (json['data'] != null) {
      data = <CategoriesListData>[];
      json['data'].forEach((v) {
        data!.add( CategoriesListData.fromJson(v));
      });
    }
  }
}
class CategoriesListData{
  int? id;
  String? name;
  String? image;

  CategoriesListData.fromJson(Map<String,dynamic>json){

    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
