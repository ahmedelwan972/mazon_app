import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/shared/components/constants.dart';
import 'package:mazon/shared/network/local/cache_helper.dart';
import '../../layout/cubit/states.dart';
import '../../layout/mazon_layout.dart';
import '../../shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordCController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){
        if(state is RegisterSuccessState){
          if(state.registerModel!.status!){
            CacheHelper.saveData(
                key: 'token',
                value: state.registerModel!.data!.token
            ).then((value) {
              token = state.registerModel!.data!.token;
              MazonCubit.get(context).currentIndex = 0;
              MazonCubit.get(context).getHome();
              navigateAndFinish(context, MazonLayout());
            }).catchError((e){print(e.toString());});
          }else{
            showToast(msg: state.registerModel!.message!, toastState: true);
          }
        }
      },
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        return Scaffold(
          body: Center(
            child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(fontSize: 50),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Register now for show best offers',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 82.5,
                              ),
                              CircleAvatar(
                                radius: 80,
                                backgroundImage:cubit.profileImage == null
                                    ? null
                                    :  FileImage(cubit.profileImage!),
                              ),
                              InkWell(
                                onTap: (){
                                  cubit.getPickedLogo();
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                            ],
                          ),
                          Text('tap at camera to choose photo'),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              controller: nameController,
                              label: 'Name',
                              suffix: Icons.person,
                              validator: (value){
                                if(value.isEmpty) {
                                  return 'Name is Empty';
                                }
                              }
                          ),
                          SizedBox(
                            height: 10,
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
                              controller: phoneController,
                              label: 'Phone',
                              suffix: Icons.phone,
                              type: TextInputType.phone,
                              validator: (value){
                                if(value.isEmpty) {
                                  return 'Phone is Empty';
                                }
                              }
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                              controller: passwordController,
                              label: 'Password',
                              isPassword: cubit.registerPassword,
                              suffix: cubit.registerPassword ? Icons.visibility : Icons.visibility_off,
                              suffixPressed: (){
                                cubit.changeVisRegister();
                              },
                              type: TextInputType.visiblePassword,
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Password is Empty';
                                }else if(value.length < 6 ){
                                  return 'Password is incorrect';
                                }
                              }
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                              controller: passwordCController,
                              label: 'Confirm Password',
                              isPassword: cubit.registerPasswordC,
                              suffix: cubit.registerPasswordC ? Icons.visibility : Icons.visibility_off,
                              suffixPressed: (){
                                cubit.changeVisRegisterC();
                              },
                              type: TextInputType.visiblePassword,
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Password is Empty';
                                }else if(value.length < 6 ){
                                  return 'Password is incorrect';
                                }else if(value != passwordController.text)
                                {
                                  return 'password does not match';
                                }
                              }
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          state is! RegisterLoadingState ?
                          defaultButton(
                            function: (){
                              if(formKey.currentState!.validate()){
                                if(cubit.profileImage !=  null){
                                  cubit.register(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordCController.text,
                                  );
                                }else {
                                  showToast(msg: 'Choose Photo', toastState: true);
                                }
                              }
                            },
                            text: 'Register',
                          ):Center(child: CircularProgressIndicator()),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'i have account  '
                              ),
                              InkWell(
                                onTap: (){
                                  if(state is! RegisterLoadingState){
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  'Back',
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
                )
            ),
          ),
        );
      },
    );
  }
}
