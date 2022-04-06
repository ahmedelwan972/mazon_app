import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/modules/auth/register_screen.dart';
import 'package:mazon/shared/components/components.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/mazon_layout.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';


class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){
        if(state is LoginSuccessState){
          if(state.loginModel!.status!){
            CacheHelper.saveData(
                key: 'token',
                value: state.loginModel!.data!.token
            ).then((value) {
              token = state.loginModel!.data!.token;
              MazonCubit.get(context).currentIndex = 0;
              MazonCubit.get(context).getHome();
              navigateAndFinish(context, MazonLayout());
            }).catchError((e){print(e.toString());});
          }else{
            showToast(msg: state.loginModel!.message!, toastState: true);
          }
        }
        checkNet(context);
      },
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: Image(
                          image: AssetImage('assets/images/signin_bg@2x.png'),
                        ),
                      ),
                      Text(
                        'Login',
                        style: TextStyle(fontSize: 50),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Login now for show best offers',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                          controller: emailController,
                          label: 'Email Address',
                          suffix: Icons.email,
                          type: TextInputType.emailAddress,
                          validator: (value){
                            if(value.isEmpty) {
                              return 'Email Address is Empty';
                            }
                            else if(!value.contains('@')&&!value.contains('.'))
                            {
                              return 'Email Address is incorrect';
                            }
                          }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          label: 'Password',
                          isPassword: cubit.loginPassword,
                          suffix: cubit.loginPassword ? Icons.visibility : Icons.visibility_off,
                          suffixPressed: (){
                            cubit.changeVisLogin();
                          },                            type: TextInputType.visiblePassword,
                          validator: (value){
                            if(value.isEmpty){
                              return 'Password is Empty';
                            }else if(value.length < 6 ){
                              return 'Password is incorrect';
                            }
                          }
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      state is! LoginLoadingState ?
                      defaultButton(
                        function: (){
                          if(formKey.currentState!.validate()){
                            cubit.login(
                                email: emailController.text,
                                password: passwordController.text,
                            );
                          }
                        },
                        text: 'Login',
                      ):Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'no have account ? '
                          ),
                          InkWell(
                            onTap: (){
                              if(state is! LoginLoadingState){
                                navigateTo(context, RegisterScreen());
                              }
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Colors.cyan
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
