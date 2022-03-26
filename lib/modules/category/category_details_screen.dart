import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import '../../shared/components/components.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          appBar: appBar(context,'Category Details'),
          body: ConditionalBuilder(
            condition: cubit.categoryDetailsModel != null && state is! GetCategoryDetailsLoadingState,
            fallback: (context)=>Center(child: CircularProgressIndicator()),
            builder: (context)=>ListView.separated(
              itemBuilder: (context, index) => buildProductItem(context,data: cubit.categoryDetailsModel!.data!.data![index]),
              separatorBuilder: (context, index) =>SizedBox(height: 10,),
              itemCount: cubit.categoryDetailsModel!.data!.data!.length,
            ),
          ),
        );
      },
    );
  }
}
