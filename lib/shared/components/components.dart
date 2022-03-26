import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/models/category_models/category_model.dart';
import 'package:mazon/models/favorites_models/favorites_model.dart';
import '../../layout/mazon_layout.dart';
import '../../modules/cart/cart_screen.dart';
import '../../modules/product/product_screen.dart';
import '../../modules/search/search_screen.dart';
import '../styles/colors.dart';
import 'constants.dart';

Widget defaultButton({
  double width = double.infinity,
  bool isUpperCase = true,
  double radius = 15.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          function();
        },
      ),
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

Widget defaultFormField({
  String? text,
  TextEditingController? controller,
  bool isPassword = false,
  FormFieldValidator? validator,
  TextInputType? type,
  String? label,
  bool enabled = true,
  Function? suffixPressed,
  Function? onChanged,
  IconData? suffix,
}) =>
    TextFormField(
      obscureText: isPassword,
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      onChanged: (value){
        if(onChanged != null){
          onChanged(value);
        }
      } ,
      decoration: InputDecoration(
        hintText: text,
        labelText: label,
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  {
                    if(suffixPressed != null){
                      suffixPressed();
                    }
                  }
                },
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: validator,
    );

Future<bool?> showToast({required String msg, bool? toastState}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: toastState != null
            ? toastState
            ? Colors.yellow[900]
            : Colors.red
            : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

Future<void> refresh(context)
{
  return Future.delayed(
    Duration(seconds: 1),
  ).then((value) {});
//ElMahalCubit.get(context).justEmitState()

}


checkNet(context){
  if(!result!){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No internet connection'),
        content: Container(
          height: 60,
          width: 80,
          color: defaultColor,
          child: TextButton(
            onPressed: () {
              MazonCubit.get(context).justEmitState();
              Navigator.pop(context);
            },
            child: Text(
              'Click to retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

appBar(context,title) {
  return AppBar(
    leading: IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,
      ),
    ),
    actions: [
      IconButton(
          onPressed:(){
            MazonCubit.get(context).getCarts();
            navigateTo(context, CartScreen());
          },
          icon: Icon(Icons.shopping_cart)),
      IconButton(
          onPressed:(){
            navigateTo(context, SearchScreen());
          },
          icon: Icon(Icons.search)),
    ],
    flexibleSpace: linearGradient(),
    backgroundColor: defaultColor,
    centerTitle: true,
    title: Text(
      title,
    ),

  );
}


linearGradient(){
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black,Colors.red.shade900],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        )
    ),
  );
}

buildProductItem(context, {data,bool isOld = true,bool isCart = false,index}){
  var cubit = MazonCubit.get(context);
  return InkWell(
    onTap: (){
      cubit.product(data!.id);
      navigateTo(context, ProductScreen());
    },
    child: Container(
      height: 140,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height:140,
                width: 140,
                child: Image(
                  image: NetworkImage(
                    data!.image!
                  ),
                  height:140,
                  width: 140,
                  errorBuilder: (context,error,stackTrace)=>Icon(Icons.error),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              if (data!.discount != 0 && isOld)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  color: Colors.red,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    data!.name!,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  height: 80,
                  width: 140,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      data!.price!.round().toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),),
                    if (data!.discount != 0 && isOld)
                      Text(
                      data!.oldPrice!.round().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                        decoration: TextDecoration.lineThrough,
                      ),),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          if(!isCart)
            IconButton(
            onPressed: () {
              cubit.changeCart(data!.id!);
            },
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: cubit.carts[data!.id]! ? defaultColor : Colors.grey[500],
              child: Icon(
                Icons.shopping_cart,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
          if(!isCart)
            IconButton(
            onPressed: () {
              cubit.changeFav(data!.id!);
            },
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: cubit.favorites[data!.id!]! ? Colors.red : Colors.grey[500],
              child: Icon(
                Icons.favorite_border,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
          if(isCart)
            Column(
            children: [
              IconButton(
                onPressed: () {
                  cubit.changeCart(data!.id!);
                },
                icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: cubit.carts[data!.id]! ? defaultColor : Colors.grey[500],
                  child: Icon(
                    Icons.shopping_cart,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(cubit.cartsModel!.data!.cartItems![index].quantity!.toString()),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if(cubit.cartsModel!.data!.cartItems![index].quantity! !=1){
                        cubit.addMoreItemInCartOrRemove(
                          cubit.cartsModel!.data!.cartItems![index].id!,
                          cubit.cartsModel!.data!.cartItems![index].quantity! -1,
                        );
                        cubit.getCarts();
                      }
                    },
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundColor:  Colors.red,
                      child: Icon(
                        Icons.remove,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                       cubit.addMoreItemInCartOrRemove(
                         cubit.cartsModel!.data!.cartItems![index].id!,
                         cubit.cartsModel!.data!.cartItems![index].quantity! +1,
                       );
                       cubit.getCarts();
                    },
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.add,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}