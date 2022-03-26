import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/models/carts_models/order_models/get_order_model.dart';
import 'package:mazon/modules/cart/order_details_screen.dart';

import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit, MazonStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MazonCubit.get(context);
        return Scaffold(
          appBar: appBar(context, 'Orders'),
          body: ConditionalBuilder(
            condition: cubit.getOrderModel != null && state is! GetOrderLoadingState,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) {
              if(cubit.getOrderModel!.data!.data!.isNotEmpty){
               return ListView.separated(
                  itemBuilder: (context,index)=>buildOrderItem(cubit.getOrderModel!.data!.data![index],context),
                  separatorBuilder: (context,index)=>Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  itemCount: cubit.getOrderModel!.data!.data!.length,
                );
              }else{
                return Text('You don\'t have orders yet');
              }
            },
          ),
        );
      },
    );
  }

  buildOrderItem(Data model,context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status : ${model.status!}'),
            Row(
              children: [
                Text('Date : ${model.date!}'),
                Spacer(),
                Container(
                  height: 40,
                    width: 150,
                    child: defaultButton(
                        function: (){
                          MazonCubit.get(context).getOrderDetails(model.id!);
                          navigateTo(context, OrderDetailsScreen());
                        },
                        text: 'Show Details'),
                ),
              ],
            ),
            Text('Total : ${model.total.toString()}'),
          ],
        ),
      ),
    );
  }

}
