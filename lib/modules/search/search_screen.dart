import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/layout/mazon_layout.dart';
import 'package:mazon/shared/components/components.dart';

import '../../shared/styles/colors.dart';
import '../cart/cart_screen.dart';

class SearchScreen extends StatelessWidget {
var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: defaultColor,
            centerTitle: true,
            title: Text('Search'),
            leading: IconButton(
              onPressed: (){
                navigateAndFinish(context,MazonLayout());
              },
              icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,
              ),
            ),
            actions: [
              Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  IconButton(
                    onPressed:(){
                      if(cubit.homeModel != null){
                        cubit.getCarts();
                        navigateTo(context, CartScreen());
                      }
                    },
                    icon: Icon(
                        Icons.shopping_cart
                    ),
                  ),
                  if(cubit.cart)
                    Align(
                    alignment: AlignmentDirectional.topStart,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Text(cubit.cartsModel!=null ? cubit.cartsModel!.data!.cartItems!.length.toString():'',style: TextStyle(color: Colors.white,fontSize: 14),),
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace:linearGradient(),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultFormField(
                    controller: searchController,
                    label: 'type here to search',
                    onChanged: (value){
                      cubit.search(value);
                      if(value.isEmpty){
                        searchController.text = '';
                      }
                    }
                ),
              ),
              if(state is GetSearchLoadingState)
                SizedBox(height: 15,),
              if(state is GetSearchLoadingState)
                LinearProgressIndicator(),
              if( cubit.searchModel!=null &&cubit.searchModel!.data!.data!.isEmpty && state is GetSearchSuccessState)
                Text('There are no search results',),
              if(searchController.text.isNotEmpty&&state is! GetSearchLoadingState&&cubit.searchModel !=null)
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildProductItem(context,data: cubit.searchModel!.data!.data![index],isOld:false),
                    separatorBuilder: (context, index) =>SizedBox(height: 10,),
                    itemCount: cubit.searchModel!.data!.data!.length,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
