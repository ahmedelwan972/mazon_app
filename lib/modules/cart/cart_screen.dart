import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/modules/cart/order_screen.dart';
import 'package:mazon/shared/components/components.dart';
import 'package:mazon/shared/styles/colors.dart';

import '../../layout/mazon_layout.dart';
import '../search/search_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        centerTitle: true,
        title: Text('Cart'),
        leading: IconButton(
          onPressed: (){
            navigateAndFinish(context,MazonLayout());
          },
          icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              navigateTo(context, SearchScreen());
            },
            icon: Icon(Icons.search,color: Colors.white,
            ),
          ),
        ],
        flexibleSpace:linearGradient(),
      ),
      body: BlocConsumer<MazonCubit,MazonStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = MazonCubit.get(context);
          return ConditionalBuilder(
            condition: cubit.cartsModel!=null&& state is! GetCartsLoadingState&& state is! GetHomeLoadingState,
            fallback: (context)=>Center(child: CircularProgressIndicator()),
            builder: (context)=>Column(
              children: [
                cubit.cartsModel!.data!.cartItems!.isNotEmpty ?
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildProductItem(context,data: cubit.cartsModel!.data!.cartItems![index].product,isCart: true,index: index),
                    separatorBuilder: (context, index) =>SizedBox(height: 10,),
                    itemCount: cubit.cartsModel!.data!.cartItems!.length,
                  ),
                ): Center(child: Text(
                  'add items in cart to check out',
                )),
                if(cubit.cartsModel!.data!.cartItems!.isNotEmpty)
                  Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultButton(function: (){
                    navigateTo(context, OrderScreen());
                  }, text: 'Check Out ${cubit.cartsModel!.data!.total} LE',),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
