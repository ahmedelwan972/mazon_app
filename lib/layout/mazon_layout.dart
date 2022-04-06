import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/modules/setting/notifications_screen.dart';
import 'package:mazon/shared/components/components.dart';
import 'package:mazon/shared/styles/colors.dart';
import '../modules/cart/cart_screen.dart';
import '../modules/search/search_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class MazonLayout extends StatelessWidget {
  const MazonLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit, MazonStates>(
      listener: (context, state) {
        checkNet(context);
      },
      builder: (context, state) {
        var cubit = MazonCubit.get(context);
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            flexibleSpace: linearGradient(),
            actions: [
              Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  IconButton(
                    onPressed: () {
                      if (cubit.homeModel != null) {
                        cubit.getCarts();
                        navigateTo(context, CartScreen());
                      }
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                  if(cubit.cart)
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Text(
                        cubit.cartsModel != null
                            ? cubit.cartsModel!.data!.cartItems!.length.toString()
                            : '',
                        style: TextStyle(color: Colors.white,fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.search)),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                if (cubit.notificationModel == null) {
                  cubit.getNotifications();
                }
                navigateTo(context, NotificationsScreen());
              },
            ),
            backgroundColor: defaultColor,
            centerTitle: true,
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            color: defaultColor.withOpacity(.9),
            index: cubit.currentIndex,
            backgroundColor: Colors.transparent,
            onTap: (index) {
              if (index == 2 && cubit.favoriteModel == null) {
                cubit.getFav();
              }
              if (index == 3 && cubit.authModel == null) {
                cubit.getProfile();
              }
              cubit.changeIndex(index);
            },
            items: [
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              Icon(
                Icons.category,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
