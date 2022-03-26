import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/mazon_layout.dart';
import 'package:mazon/modules/auth/login_screen.dart';
import 'package:mazon/shared/bloc_observer.dart';
import 'package:mazon/shared/components/constants.dart';
import 'package:mazon/shared/network/local/cache_helper.dart';
import 'package:mazon/shared/network/remote/dio.dart';
import 'modules/onboarding/onboarding_screen.dart';

void main()async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init1();
  Widget widget;
  onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);
  if (onBoarding != null) {
    if (token != null) {
      widget = MazonLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }
  runApp( MyApp(startWidget: widget,));


}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp({
    required this.startWidget,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> MazonCubit()..getHome()..checkInterNet(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(
              color: Colors.white
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black
            )
          )
        ),
        home: startWidget,
      ),
    );
  }
}

