import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/models/home_models/home_model.dart';
import 'package:mazon/shared/styles/colors.dart';

import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../category/category_details_screen.dart';
import '../product/product_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit, MazonStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MazonCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null &&
              cubit.categoriesModel!=null &&
              state is! GetHomeLoadingState&&
              state is! GetCategoryLoadingState,
          fallback: (context) => Center(child: CircularProgressIndicator()),
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider(
                  items: cubit.homeModel!.data!.banners!
                      .map((e) => Image(
                            image: NetworkImage(e.image!),
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 200,
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
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              buildCategoryItem(context,cubit.categoriesModel!.data!.data![index]),
                          separatorBuilder: (context, index) => SizedBox(
                            width: 5,
                          ),
                          itemCount: cubit.categoriesModel!.data!.data!.length,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Products',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[50],
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1 / 1.530,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          crossAxisCount: 2,
                          children: List.generate(
                            cubit.homeModel!.data!.products!.length,
                            (index) => gridViewBuild(context,
                                cubit.homeModel!.data!.products![index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

gridViewBuild(context, Products model) {
  var cubit = MazonCubit.get(context);
  return InkWell(
    onTap: () {
      cubit.product(model.id!);
      navigateTo(context, ProductScreen());
    },
    child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Image(
                  image: NetworkImage(
                    model.image!,
                  ),
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
                  width: double.infinity,
                  height: 200,
                ),
              ),
              if (model.discount != 0)
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
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
                ),
                SizedBox(
                  height: 3.5,
                ),
                Row(
                  children: [
                    Text(
                      model.price!.round().toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (model.discount != 0)
                      Text(
                        model.oldPrice!.round().toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        cubit.changeCart(model.id!);
                      },
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: cubit.carts[model.id]! ? defaultColor : Colors.grey[500],
                        child: Icon(
                          Icons.shopping_cart,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cubit.changeFav(model.id!);
                      },
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: cubit.favorites[model.id]! ? Colors.red : Colors.grey[500],
                        child: Icon(
                          Icons.favorite_border,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

buildCategoryItem(context,CategoriesListData model) {
  return InkWell(
    onTap: () {
      MazonCubit.get(context).getCategoryDetails(model.id!);
      navigateTo(context, CategoryDetailsScreen());    }
    ,
    child: Container(
      height: 100,
      width: 150,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
              model.image!,
            ),
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
          Container(
            height: 20,
            width: 150,
            alignment: AlignmentDirectional.center,
            color: Colors.black.withOpacity(0.5),
            child: Text(
              model.name!,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}
