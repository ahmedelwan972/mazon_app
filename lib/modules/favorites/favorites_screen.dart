import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';

import '../../shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit, MazonStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MazonCubit.get(context);
        return ConditionalBuilder(
            condition:
                cubit.favoriteModel != null && state is! GetFavLoadingState,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) {
              if (cubit.favoriteModel!.data!.data!.isNotEmpty) {
                return ListView.separated(
                  itemBuilder: (context, index) => buildProductItem(context,
                      data: cubit.favoriteModel!.data!.data![index].product),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemCount: cubit.favoriteModel!.data!.data!.length,
                );
              } else {
                return Center(child: Text('No items in favorites'));
              }
            });
      },
    );
  }
}
