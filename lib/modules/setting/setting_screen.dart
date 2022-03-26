import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/modules/auth/login_screen.dart';
import 'package:mazon/modules/setting/update_screen.dart';
import 'package:mazon/shared/components/components.dart';
import 'package:mazon/shared/styles/colors.dart';

import '../cart/orders_screen.dart';

class SettingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return ConditionalBuilder(
          condition: state is! GetProfileLoadingState && cubit.authModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator()),
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 190,
                        width: 190,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadiusDirectional.all(Radius.circular(100)),
                        ),
                      ),
                      Container(
                        height: 180,
                        width: 180,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.all(Radius.circular(100)),
                        ),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(cubit.authModel!.data!.image!),
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
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
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
                          'Name : ${cubit.authModel!.data!.name!}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Email : ${cubit.authModel!.data!.email!}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Phone : ${cubit.authModel!.data!.phone!}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    function: (){
                      navigateTo(context, UpdateScreen());
                    },
                    text: 'Update profile',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    function: (){
                      cubit.getOrders();
                      navigateTo(context, OrdersScreen());
                    },
                    text: 'my orders',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  state is! LogoutLoadingState  ?
                  defaultButton(
                    function:(){
                      cubit.logout();
                      navigateAndFinish(context, LoginScreen());
                    },
                    text: 'Log Out',
                  ): Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
