import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../auth/login_screen.dart';

class BoardingModel {
  late String image;
  late String title;
  late String text;

  BoardingModel({
    required this.image,
    required this.title,
    required this.text,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onboarding_1.PNG',
      title: 'تسوق من مكانك',
      text: 'اطلب كل ما تحتاج من مكانك وسوف يصلك الي باب البيت بسرعه و بامان',
    ),
    BoardingModel(
      image: 'assets/images/onboarding_2.PNG',
      title: 'اضف كل ما تريد فالعربه',
      text: 'ينقصك بعض الاغراض التي عليك احضارها',
    ),
    BoardingModel(
      image: 'assets/images/onboarding_3.PNG',
      title: 'دايما يوجد هدايا',
      text: 'انهي جولتك من التسوق وسوف تري هديه بانتظارك',
    ),
  ];
  var pageController = PageController();
  bool isLast = false;

  void submit()
  {
    CacheHelper.saveData(key: 'onBoarding', value: true,).then((value)
    {
      if(value) navigateAndFinish(context,  LoginScreen());
    });


  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){
        if (result != null){
          if(!result!){
            checkNet(context);
          }
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(onPressed: submit,
                child: Text('SKIP'),
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemBuilder: (context, index) => buildItem(boarding[index]),
                      itemCount: boarding.length,
                      onPageChanged: (int index)
                      {
                        if(index == boarding.length -1)
                        {
                          setState(() {
                            isLast= true;
                          });
                        } else
                        {
                          isLast=false;
                        }
                      },
                      controller: pageController,
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SmoothPageIndicator(
                        controller: pageController,
                        count: boarding.length,
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          dotHeight: 10,
                          dotWidth: 10,
                          expansionFactor: 4,
                          spacing: 5,
                          activeDotColor: Colors.teal,
                        ),
                      ),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          if(isLast)
                          {
                            submit();
                          }
                          else
                          {
                            pageController.nextPage(
                                duration: Duration(
                                  milliseconds: 750,
                                ),
                                curve: Curves.fastLinearToSlowEaseIn);
                          }

                        },
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  buildItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          child: Image(
            image: AssetImage(model.image),
          )),
      SizedBox(
        height: 30,
      ),
      Text(
        model.title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        model.text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 30,
      ),
    ],
  );
}
