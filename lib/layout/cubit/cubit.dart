import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/shared/network/local/cache_helper.dart';
import 'package:mazon/shared/network/remote/dio.dart';

import '../../models/auth_models/auth_model.dart';
import '../../models/carts_models/carts_model.dart';
import '../../models/carts_models/order_models/add_order_model.dart';
import '../../models/carts_models/order_models/get_order_model.dart';
import '../../models/carts_models/order_models/order_details_model.dart';
import '../../models/category_models/category_model.dart';
import '../../models/favorites_models/favorites_model.dart';
import '../../models/home_models/home_model.dart';
import '../../models/notification_models/notification_model.dart';
import '../../models/product_models/product_model.dart';
import '../../models/search_models/search_model.dart';
import '../../modules/category/category_screen.dart';
import '../../modules/favorites/favorites_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/setting/setting_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/end_point.dart';

class MazonCubit extends Cubit<MazonStates> {
  MazonCubit() : super(InitState());
  static MazonCubit get(context) => BlocProvider.of(context);

  List<Widget> screen = [
    HomeScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  List<String> titles = [
    'Home',
    'Category',
    'Favorites',
    'Setting',
  ];
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

////////////////////////////////////////Auth//////////////////////////////////

  File? profileImage;
  var picker = ImagePicker();
  String? profileString;
  Future<void> getPickedLogo() async {
    var pickedLogo = await picker.getImage(source: ImageSource.gallery);

    if (pickedLogo != null) {
      profileImage = File(pickedLogo.path);
      emit(PickLogoSuccessState());
    } else {
      print('no image selected');
      emit(PickLogoErrorState());
    }
  }

  Future<void> method3() async {
    final bytes = File(profileImage!.path).readAsBytesSync();
    profileString = base64Encode(bytes);
  }

  File? updateProfileImage;
  String? updateProfileString;
  Future<void> getPickedImage() async {
    var pickedLogo = await picker.getImage(source: ImageSource.gallery);

    if (pickedLogo != null) {
      updateProfileImage = File(pickedLogo.path);
      emit(PickLogoSuccessState());
    } else {
      print('no image selected');
      emit(PickLogoErrorState());
    }
  }

  Future<void> method() async {
    final bytes = File(updateProfileImage!.path).readAsBytesSync();
    updateProfileString = base64Encode(bytes);
  }

  bool registerPassword = true;
  bool registerPasswordC = true;
  bool loginPassword = true;


  void changeVisRegister() {
    registerPassword = !registerPassword;
    emit(JustEmitState());
  }

  void changeVisRegisterC() {
    registerPasswordC = !registerPasswordC;
    emit(JustEmitState());
  }

  void changeVisLogin() {
    loginPassword = !loginPassword;
    emit(JustEmitState());
  }

  bool changePasswordO = true;
  bool changePasswordN = true;
  bool changePasswordNC = true;

  void changeVisOld() {
    changePasswordO = !changePasswordO;
    emit(JustEmitState());
  }

  void changeVisNew() {
    changePasswordN = !changePasswordN;
    emit(JustEmitState());
  }

  void changeVisNewc() {
    changePasswordNC = !changePasswordNC;
    emit(JustEmitState());
  }

  AuthModel? authModel;

  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    method3();
    emit(RegisterLoadingState());
    await DioHelper.postData(
      url: registerE,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'image': profileString,
      },
    ).then((value) {
      authModel = AuthModel.fromJson(value.data);
      emit(RegisterSuccessState(authModel));
    }).catchError((e) {
      print(e.toString());
      emit(RegisterErrorState());
    });
  }

  void login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await DioHelper.postData(
      url: loginE,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      authModel = AuthModel.fromJson(value.data);
      emit(LoginSuccessState(authModel));
    }).catchError((e) {
      print(e.toString());
      emit(LoginErrorState());
    });
  }

  void getProfile() async {
      emit(GetProfileLoadingState());
      await DioHelper.getData(
        url: profile,
        token: token,
      ).then((value) {
        authModel = AuthModel.fromJson(value.data);
        emit(GetProfileSuccessState());
      }).catchError((e) {
        emit(GetProfileErrorState());
      });

  }

  void logout() async {
    emit(LogoutLoadingState());
    await DioHelper.getData(
      url: logoutE,
      token: token,
    ).then((value) {
      CacheHelper.removeData('token');
      token = null;
      emit(LogoutSuccessState());
    }).catchError((e) {
      emit(LogoutErrorState());
    });
  }

  void updateUserData(
    String name,
    String email,
    String phone,
  ) async {
    if (updateProfileImage != null) method();
    emit(UpdateUserLoadingState());
    await DioHelper.putData(url: updateProfile, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'image': updateProfileString,
    }).then((value) {
      authModel = AuthModel.fromJson(value.data);
      emit(UpdateUserSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(UpdateUserErrorState());
    });
  }

  ChangePasswordMode? changePass;

  void changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    await DioHelper.postData(
      url: changePasswordE,
      token: token,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    ).then((value) {
      changePass = ChangePasswordMode.fromJson(value.data);
      print(value.data);
      emit(ChangePasswordSuccessState());
    }).catchError((e) {
      emit(ChangePasswordErrorState());
    });
  }


////////////////////////////////////////Home/////////////////////////

  HomeModel? homeModel;
  Map<int,bool> favorites={};
  Map<int,bool> carts={};

  void getHome()async{
    if(token != null){
      favorites={};
      carts={};
      emit(GetHomeLoadingState());
      await DioHelper.getData(
        url: home,
        token: token,
      ).then((value) {
        homeModel = HomeModel.fromJson(value.data);
        homeModel!.data!.products!.forEach((element) {
          favorites.addAll({
            element.id! : element.inFavorites!
          });
          carts.addAll({
            element.id! : element.inCart!
          });
        });
        getCategory();
        emit(GetHomeSuccessState());
      }).catchError((e){
        print(e.toString());
        emit(GetHomeErrorState());
      });
    }
  }

  CategoriesModel? categoriesModel;

  void getCategory()async{
    emit(GetCategoryLoadingState());
    await DioHelper.getData(
        url: categories,
    ).then((value) {
      categoriesModel= CategoriesModel.fromJson(value.data);
      emit(GetCategorySuccessState());
    }).catchError((e){
      emit(GetCategoryErrorState());
    });
  }


  FavoriteModel? favoriteModel;
  void getFav()async{
    favoriteModel;
    emit(GetFavLoadingState());
    await DioHelper.getData(
      url: favoritesGE,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      emit(GetFavSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(GetFavErrorState());
    });
  }

  void changeFav(int productId)async{
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavSuccessState());
    await DioHelper.postData(
       url: favoritesE,
       token: token,
       data: {
          'product_id': productId,
        }
    ).then((value) {
      getFav();
    }).catchError((e){
     favorites[productId] = !favorites[productId]!;
     emit(ChangeFavErrorState());
    });
  }

  CartsModel? cartsModel;
  void getCarts()async{
    emit(GetCartsLoadingState());
    await DioHelper.getData(
        url: cartsGE,
        token: token
    ).then((value) {
      cartsModel = CartsModel.fromJson(value.data);
      emit(GetCartsSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(GetCartsErrorState());
    });
  }
  void changeCart(int productId)async{
    carts[productId] = !carts[productId]!;
    emit(ChangeCartSuccessState());
    await DioHelper.postData(
        url: cartsE,
        token: token,
        data: {
          'product_id': productId,
        }
    ).then((value) {
      getCarts();
    }).catchError((e){
     carts[productId] = !carts[productId]!;
     emit(ChangeCartErrorState());
    });
  }
  CategoryModel? categoryDetailsModel;

  void getCategoryDetails(int categoryId)async{
    emit(GetCategoryDetailsLoadingState());
   await DioHelper.getData(
      url: 'categories/$categoryId',
    ).then((value) {
     categoryDetailsModel = CategoryModel.fromJson(value.data);
     categoryDetailsModel!.data!.data!.forEach((element) {
       if(!carts.containsKey(element.id)||!favorites.containsKey(element.id)){
         carts.addAll({
           element.id! : element.inCart!
         });
         favorites.addAll({
           element.id! : element.inCart!
         });
       }
     });
     emit(GetCategoryDetailsSuccessState());
    }).catchError((e){
     emit(GetCategoryDetailsErrorState());
    });
  }

  ProductModel? productModel;
  void product(int id)async{
    emit(GetProductDetailsLoadingState());
   await DioHelper.getData(
        url: 'products/$id',
        token: token,
    ).then((value) {
      productModel= ProductModel.fromJson(value.data);
      emit(GetProductDetailsSuccessState());
   }).catchError((e){
     emit(GetProductDetailsErrorState());
   });
  }

  SearchModel? searchModel;
  void search(String text)async{
    emit(GetSearchLoadingState());
    await DioHelper.postData(
        url: searchE,
        token: token,
        data: {
          'text':text,
        }).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      searchModel!.data!.data!.forEach((element) {
        if(!carts.containsKey(element.id)||!favorites.containsKey(element.id)){
          carts.addAll({
            element.id! : element.inCart!
          });
          favorites.addAll({
            element.id! : element.inCart!
          });
        }
      });
      emit(GetSearchSuccessState());
    }).catchError((e){
      emit(GetSearchErrorState());
    });
  }

  NotificationModel? notificationModel;

  getNotifications()async{
    emit(GetNotificationLoadingState());
    await DioHelper.getData(
      url: notifications,
      token: token,
    ).then((value) {
      notificationModel = NotificationModel.fromJson(value.data);
      emit(GetNotificationSuccessState());
    }).catchError((e){
      emit(GetNotificationErrorState());
    });
  }

////////////////////////////////////Add Order//////////////////////////



  bool isPaymentMethod = false;
  bool isAddOrder = false;
  int paymentMethod = 1;

  justEmitState(){
    emit(JustEmitState());
  }


  AddOrderModel? addOrderModel;


  addOrder({
    String? promoCode,
})async{
    emit(AddOrderLoadingState());
    await DioHelper.postData(
      url: orders,
      token: token,
      data: {
        'address_id': 35,
        'payment_method':paymentMethod,
        'promo_code_id':promoCode??false,
        'use_points':false,
      },
    ).then((value){
      addOrderModel = AddOrderModel.fromJson(value.data);
      print(value.data);
      emit(AddOrderSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(AddOrderErrorState());
    });
  }
  String? message;
  bool? status;
  promoCodeeValidate(String code)async{
    emit(AddOrderLoadingState());
    await DioHelper.postData(
        url: 'promo-codes/validate',
        token: token,
        data: {
          'code' : code,
        }).then((value) {
      message = value.data['message'];
      status = value.data['status'];
      showToast(msg: message!);
      if(status!){
        addOrder(promoCode: code);
      }
      emit(CheckCodeSuccessState());
    }).catchError((e){
      emit(CheckCodeErrorState());
    });
  }


  GetOrderModel? getOrderModel;

  getOrders()async{
    emit(GetOrderLoadingState());
    await DioHelper.getData(
        url: orders,
        token: token,
    ).then((value){
      //print(value.data);
      getOrderModel = GetOrderModel.fromJson(value.data);
      emit(GetOrderSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(GetOrderErrorState());
    });
  }


  OrderDetailsModel? orderDetailsModel;


  getOrderDetails(int id)async{
    emit(GetOrderDetailsLoadingState());
    await DioHelper.getData(
        url: 'orders/$id',
        token: token,
    ).then((value) {
      orderDetailsModel = OrderDetailsModel.fromJson(value.data);
      emit(GetOrderDetailsSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(GetOrderDetailsErrorState());
    });
  }


  cancelOrder(int id)async{
    emit(CancelOrderLoadingState());
    await DioHelper.getData(
        url:'orders/$id/cancel' ,
        token: token,
    ).then((value){
      emit(CancelOrderSuccessState());
    }).catchError((e){
      emit(CancelOrderErrorState());
    });

  }
  
  
  addMoreItemInCartOrRemove(int id,int quantity)async{
    emit(ChangeItemInCartLoadingState());
    await DioHelper.putData(
        url: 'carts/$id',
        token: token,
        data: {
          'quantity': quantity,
        },
    ).then((value) {
      emit(ChangeItemInCartSuccessState());
    }).catchError((e){
      emit(ChangeItemInCartErrorState());
    });
  }


  checkInterNet(){
    InternetConnectionChecker().onStatusChange.listen((event) {
      final state = event == InternetConnectionStatus.connected;
      result = state;
      print(result);
      emit(CheckNetState());
    });



  }
}
