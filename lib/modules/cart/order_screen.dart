import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/layout/mazon_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../search/search_screen.dart';

class OrderScreen extends StatelessWidget {

  var promoController = TextEditingController();

  TextStyle style = TextStyle(
    fontSize: 20,
  );

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
            title: Text('Check Out'),
            leading: IconButton(
              onPressed: (){
                cubit.getHome();
                Navigator.pop(context);
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
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [defaultColor,Colors.black],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                )
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20
                ),
                child: Column(
                  children: [
                    if(state is! AddOrderSuccessState)
                      Column(
                      children: [
                        Text(
                          'Payment Method'
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsetsDirectional.only(
                            top: 10,
                            bottom: 20
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(
                              Radius.circular(20),
                            )
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: !cubit.isPaymentMethod ? Colors.blue :Colors.grey
                                  ),
                                  child: TextButton(
                                    onPressed: (){
                                      cubit.isPaymentMethod = false;
                                      cubit.paymentMethod = 1;
                                      cubit.justEmitState();
                                    },
                                    child: Text(
                                      'Cash',
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: cubit.isPaymentMethod ? Colors.blue :Colors.grey
                                  ),
                                  child: TextButton(
                                    onPressed: (){
                                      cubit.isPaymentMethod = true;
                                      cubit.paymentMethod = 2;
                                      cubit.justEmitState();
                                    },
                                    child: Text(
                                        'Online',
                                        style: TextStyle(
                                            color: Colors.white,
                                        ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        defaultFormField(
                          label: 'Promo code (Optional)',
                          controller: promoController,
                          type: TextInputType.number
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Total : ${cubit.cartsModel!.data!.total} LE',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        state is! AddOrderLoadingState?
                        defaultButton(
                            function: (){
                              if(promoController.text != ''){
                                cubit.promoCodeeValidate(promoController.text);
                              }else{
                                cubit.addOrder();
                              }
                              },
                            text: 'Check Out',
                        ) : Center(child: CircularProgressIndicator()),
                      ],
                    ),
                    if(state is AddOrderSuccessState)
                      Column(
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            padding: EdgeInsetsDirectional.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(color: defaultColor)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'State : ${cubit.addOrderModel!.message!}',
                                  style: style,
                                ),
                                Text(
                                  'Payment Method : ${cubit.addOrderModel!.data!.paymentMethod!}',
                                  style: style,
                                ),
                                Text(
                                  'Cost : ${cubit.addOrderModel!.data!.cost!.round().toString()}',
                                  style: style,
                                ),
                                Text(
                                  'Val : ${cubit.addOrderModel!.data!.vat!.round().toString()}',
                                  style: style,
                                ),
                                Text(
                                  'Discount : ${cubit.addOrderModel!.data!.discount!.round().toString()}',
                                  style: style,
                                ),
                                Text(
                                  'Total : ${cubit.addOrderModel!.data!.total!.round().toString()}',
                                  style: style,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          defaultButton(
                              function: (){
                                cubit.getHome();
                                navigateAndFinish(context, MazonLayout());
                              },
                              text: 'Done',
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
