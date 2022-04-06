import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/shared/components/components.dart';

import '../../models/home_models/home_model.dart';
import 'category_details_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.categoriesModel !=  null && state is! GetCategoryLoadingState,
          fallback: (context)=>Center(child: CircularProgressIndicator()),
          builder: (context)=> ListView.separated(
            itemBuilder: (context,index)=>buildCateItem(context,cubit.categoriesModel!.data!.data![index]),
            separatorBuilder: (context,index)=>SizedBox(height: 10,),
            itemCount: cubit.categoriesModel!.data!.data!.length,
          ),
        );
      },
    );
  }
}

buildCateItem(context,CategoriesListData data){
  return InkWell(
    onTap: (){
      MazonCubit.get(context).getCategoryDetails(data.id!);
      navigateTo(context, CategoryDetailsScreen());
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 140,
            width: 140,
            child: Image(
              image: NetworkImage(
                  data.image!
              ),
              //fit: BoxFit.cover,
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
              height: 140,
              width: 140,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Text(
              data.name!,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
}
