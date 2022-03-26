import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/models/notification_models/notification_model.dart';

import '../../layout/mazon_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../cart/cart_screen.dart';
import '../search/search_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          appBar: appBar(context,'Notifications'),
          body: ConditionalBuilder(
            condition: state is! GetNotificationLoadingState && cubit.notificationModel != null,
            fallback: (context)=>Center(child: CircularProgressIndicator()),
            builder: (context)=>ListView.separated(
              itemBuilder: (context,index)=>buildNotificationItem(context,cubit.notificationModel!.data!.data![index]),
              separatorBuilder: (context,index)=>Container(
                height: 1,
                width: double.infinity,
                color: defaultColor,
              ),
              itemCount: cubit.notificationModel!.data!.data!.length,
            ),
          ),
        );
      },
    );
  }

  buildNotificationItem(context,DataNotification data){
    return Container(
     // height: 100,
      padding: EdgeInsetsDirectional.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.title!,style: Theme.of(context).textTheme.headline6,),
          SizedBox(height: 10,),
          Text(data.message!,style: Theme.of(context).textTheme.subtitle2,),
        ],
      ),
    );
  }
}
