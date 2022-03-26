import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/models/carts_models/order_models/order_details_model.dart';
import 'package:mazon/shared/components/components.dart';

import '../../layout/cubit/states.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          appBar: appBar(context, 'Order Details'),
          body: ConditionalBuilder(
            condition: cubit.orderDetailsModel != null && state is! GetOrderDetailsLoadingState,
            fallback: (context)=>Center(child: CircularProgressIndicator()),
            builder: (context){
              if(cubit.orderDetailsModel!.data!.products!.isNotEmpty){
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder:(context,index)=>buildListItem(cubit.orderDetailsModel!.data!.products![index]),
                          separatorBuilder:(context,index)=>Container(height: 1,width: double.infinity,color: Colors.grey,),
                          itemCount: cubit.orderDetailsModel!.data!.products!.length,
                        ),
                        Text('Cost : ${cubit.orderDetailsModel!.data!.cost!.round()}'),
                        Text('Discount : ${cubit.orderDetailsModel!.data!.discount!.round()}'),
                        Text('Vat : ${cubit.orderDetailsModel!.data!.vat!.round()}'),
                        Text('Total : ${cubit.orderDetailsModel!.data!.total!.round()}'),
                        Text('Promo Code : ${cubit.orderDetailsModel!.data!.promoCode!}'),
                        Text('Payment Method : ${cubit.orderDetailsModel!.data!.paymentMethod!}'),
                        Text('Date : ${cubit.orderDetailsModel!.data!.date!}'),
                        Text('Status : ${cubit.orderDetailsModel!.data!.status!}'),
                        Text('City : ${cubit.orderDetailsModel!.data!.address!.city!}'),
                        Text('Region : ${cubit.orderDetailsModel!.data!.address!.region!}'),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.grey,
                          width: double.infinity,
                          height: 1,
                        ),
                        state is! CancelOrderLoadingState
                            ? Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text('Back',style: TextStyle(color: Colors.grey)),),
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: (){
                                  if(cubit.orderDetailsModel!.data!.status != 'Cancelled')
                                    openDialog(context,cubit.orderDetailsModel!.data!.id!);
                                },
                                child: Text(
                                    cubit.orderDetailsModel!.data!.status != 'Cancelled' ?'Cancel' : 'Order is Cancelled',
                                    style: TextStyle(color: Colors.redAccent)),),
                            ),
                          ],
                        )
                            : Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                );
              }else{
                return Center(child: Text('Order is Empty'));
              }
            }
          ),
        );
      },
    );
  }

  buildListItem(Products products){
    return Container(
      height: 150,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: 150,
            child: Image(
              image: NetworkImage(products.image!),
              errorBuilder: (context,error,stackTrace)=>Icon(Icons.error),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes !=
                        null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(height: 18,width: 200,child: Text('Name : ${products.name}',style: TextStyle(fontSize: 16),)),
              Text('price :${products.price}   ',style: TextStyle(fontSize: 14),),
              Text('quantity : ${products.quantity}  ',style: TextStyle(fontSize: 14),),
            ],
          ),
        ],
      ),
    );
  }

  Future openDialog(context,id) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        content: Container(
          height: 180,
          width: 120,
          child: Column(
            children: [
              Text(
                'Cancel Order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'In the event that the Order is Cancelled, it will be permanently deleted and this step cannot be reversed later',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey,
                width: double.infinity,
                height: 1,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child:Text(
                        'Back',
                        style: TextStyle(
                            color: Colors.black38
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 1,
                    height: 47,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: (){
                        MazonCubit.get(context).cancelOrder(id);
                        Navigator.pop(context);
                        MazonCubit.get(context).getOrders();
                        MazonCubit.get(context).getOrderDetails(id);
                      },
                      child:Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );}

}
