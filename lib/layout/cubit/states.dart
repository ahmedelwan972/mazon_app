import '../../models/auth_models/auth_model.dart';

abstract class MazonStates{}

class InitState extends MazonStates{}

class JustEmitState extends MazonStates{}

class ChangeIndexState extends MazonStates{}

class PickLogoSuccessState extends MazonStates{}

class PickLogoErrorState extends MazonStates{}

class RegisterLoadingState extends MazonStates{}

class RegisterSuccessState extends MazonStates{
  AuthModel? registerModel;
  RegisterSuccessState(this.registerModel);
}

class RegisterErrorState extends MazonStates{}

class LoginLoadingState extends MazonStates{}

class LoginSuccessState extends MazonStates{
  AuthModel? loginModel;
  LoginSuccessState(this.loginModel);
}

class LoginErrorState extends MazonStates{}

class GetProfileLoadingState extends MazonStates{}

class GetProfileSuccessState extends MazonStates{}

class GetProfileErrorState extends MazonStates{}

class LogoutLoadingState extends MazonStates{}

class LogoutSuccessState extends MazonStates{}

class LogoutErrorState extends MazonStates{}

class UpdateUserLoadingState extends MazonStates{}

class UpdateUserSuccessState extends MazonStates{}

class UpdateUserErrorState extends MazonStates{}

class ChangePasswordLoadingState extends MazonStates{}

class ChangePasswordSuccessState extends MazonStates{}

class ChangePasswordErrorState extends MazonStates{}

class GetHomeLoadingState extends MazonStates{}

class GetHomeSuccessState extends MazonStates{}

class GetHomeErrorState extends MazonStates{}

class GetCategoryLoadingState extends MazonStates{}

class GetCategorySuccessState extends MazonStates{}

class GetCategoryErrorState extends MazonStates{}

class GetFavLoadingState extends MazonStates{}

class GetFavSuccessState extends MazonStates{}

class GetFavErrorState extends MazonStates{}

class ChangeFavSuccessState extends MazonStates{}

class ChangeFavErrorState extends MazonStates{}

class GetCartsLoadingState extends MazonStates{}

class GetCartsSuccessState extends MazonStates{}

class GetCartsErrorState extends MazonStates{}

class ChangeCartSuccessState extends MazonStates{}

class ChangeCartErrorState extends MazonStates{}

class GetCategoryDetailsLoadingState extends MazonStates{}

class GetCategoryDetailsSuccessState extends MazonStates{}

class GetCategoryDetailsErrorState extends MazonStates{}

class GetProductDetailsLoadingState extends MazonStates{}

class GetProductDetailsSuccessState extends MazonStates{}

class GetProductDetailsErrorState extends MazonStates{}

class GetSearchLoadingState extends MazonStates{}

class GetSearchSuccessState extends MazonStates{}

class GetSearchErrorState extends MazonStates{}

class GetNotificationLoadingState extends MazonStates{}

class GetNotificationSuccessState extends MazonStates{}

class GetNotificationErrorState extends MazonStates{}

class AddOrderLoadingState extends MazonStates{}

class AddOrderSuccessState extends MazonStates{}

class AddOrderErrorState extends MazonStates{}

class CheckCodeSuccessState extends MazonStates{}

class CheckCodeErrorState extends MazonStates{}

class GetOrderLoadingState extends MazonStates{}

class GetOrderSuccessState extends MazonStates{}

class GetOrderErrorState extends MazonStates{}

class GetOrderDetailsLoadingState extends MazonStates{}

class GetOrderDetailsSuccessState extends MazonStates{}

class GetOrderDetailsErrorState extends MazonStates{}

class CancelOrderLoadingState extends MazonStates{}

class CancelOrderSuccessState extends MazonStates{}

class CancelOrderErrorState extends MazonStates{}

class ChangeItemInCartLoadingState extends MazonStates{}

class ChangeItemInCartSuccessState extends MazonStates{}

class ChangeItemInCartErrorState extends MazonStates{}

class CheckNetState extends MazonStates{}