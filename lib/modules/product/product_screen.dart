import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/shared/styles/colors.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(context,'Product Details'),
          body: ConditionalBuilder(
            condition: cubit.productModel != null && state is! GetProductDetailsLoadingState,
            fallback: (context)=>Center(child: CircularProgressIndicator()),
            builder: (context)=>Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  CarouselSlider(
                    items: cubit.productModel!.data!.images!
                        .map((e) => Image(
                      image: NetworkImage(e),
                      width: double.infinity,
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
                    ))
                        .toList(),
                    options: CarouselOptions(
                      height: 450,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      viewportFraction: 1,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      alignment: AlignmentDirectional.topCenter,
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.all(18),
                      height: 350,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  cubit.productModel!.data!.name!,
                                  style: Theme.of(context).textTheme.subtitle2!
                                      .copyWith(color: Colors.white),
                                ),
                                width: 200,
                              ),
                              Text(
                                cubit.productModel!.data!.price.toString(),
                                style: TextStyle(color: Colors.lightGreenAccent,fontSize: 14),
                              ),
                              if(cubit.productModel!.data!.discount != 0)
                                Text(
                                  cubit.productModel!.data!.oldPrice.toString(),
                                  style: TextStyle(color: Colors.white,decoration:TextDecoration.lineThrough,fontSize: 10),
                                ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  cubit.changeCart(cubit.productModel!.data!.id!);
                                },
                                icon: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: cubit.carts[cubit.productModel!.data!.id]! ? defaultColor : Colors.grey[500],
                                  child: Icon(
                                    Icons.shopping_cart,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.changeFav(cubit.productModel!.data!.id!);
                                },
                                icon: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: cubit.favorites[cubit.productModel!.data!.id!]! ? Colors.red : Colors.grey[500],
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                              cubit.productModel!.data!.description!,
                              style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                              maxLines: 15,
                              overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
