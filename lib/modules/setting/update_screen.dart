import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazon/layout/cubit/cubit.dart';
import 'package:mazon/layout/cubit/states.dart';
import 'package:mazon/shared/styles/colors.dart';

import '../../shared/components/components.dart';

class UpdateScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var oldController = TextEditingController();
  var newController = TextEditingController();
  var newCController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var formKeyTow = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MazonCubit,MazonStates>(
      listener: (context,state){
        var cubit = MazonCubit.get(context);
        if(state is UpdateUserSuccessState){
          if(cubit.authModel!.status!){
            showToast(msg: cubit.authModel!.message!);
            Navigator.pop(context);
          }else{
            showToast(msg: cubit.authModel!.message!,toastState: true);
          }
        }
        if(state is ChangePasswordSuccessState){
          if(cubit.changePass!.status!){
            showToast(msg: cubit.changePass!.message!);
            Navigator.pop(context);
          }else{
            showToast(msg: 'password incorrect',toastState: true);
          }
        }
      },
      builder: (context,state){
        var cubit = MazonCubit.get(context);
        nameController.text = cubit.authModel!.data!.name!;
        emailController.text = cubit.authModel!.data!.email!;
        phoneController.text = cubit.authModel!.data!.phone!;
        return ConditionalBuilder(
          condition: cubit.authModel != null ,
          fallback: (context)=>Center(child: CircularProgressIndicator()),
          builder: (context)=>DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: defaultColor,
                flexibleSpace:linearGradient(),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Text('Update Profile'),
                bottom: TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.red[900],
                  tabs:
                  [
                    Tab(
                      text: 'Update Date',
                    ),
                    Tab(
                      text: 'Update Password',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 190,
                                  width: 190,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadiusDirectional.all(Radius.circular(100)),
                                  ),
                                ),
                                Container(
                                  height: 180,
                                  width: 180,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.all(Radius.circular(100)),
                                  ),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: cubit.updateProfileImage == null ? NetworkImage(cubit.authModel!.data!.image!) : FileImage(cubit.updateProfileImage!) as ImageProvider,
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
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: InkWell(
                                    onTap: (){
                                      cubit.getPickedImage();
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: Icon(
                                          Icons.camera_alt
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            defaultFormField(
                                controller: nameController,
                                label: 'Name',
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Name is Empty';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                                controller: emailController,
                                label: 'Email',
                                type: TextInputType.emailAddress,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Email is Empty';
                                  }else if(!value.contains('.')){
                                    return'Email incorrect';
                                  }else if (!value.contains('@')){
                                    return'Email incorrect';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                                controller: phoneController,
                                label: 'Phone',
                                type: TextInputType.phone,
                                validator: (value){
                                  if(value.isEmpty){
                                    return  'Phone is Empty';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            state is! UpdateUserLoadingState ?
                            defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  cubit.updateUserData(
                                    nameController.text,
                                    emailController.text,
                                    phoneController.text,
                                  );
                                }
                              },
                              text: 'Update Date',
                            ): Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKeyTow,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            defaultFormField(
                                controller: oldController,
                                label: 'Old Password',
                                isPassword: cubit.changePasswordO,
                                suffix: cubit.changePasswordO ? Icons.visibility : Icons.visibility_off,
                                suffixPressed: (){
                                  cubit.changeVisOld();
                                },
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Password is Empty';
                                  }else if(value.length < 6){
                                    return 'Password incorrect';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                                controller: newController,
                                label: 'New Password',
                                isPassword: cubit.changePasswordN,
                                suffix: cubit.changePasswordN ? Icons.visibility : Icons.visibility_off,
                                suffixPressed: (){
                                  cubit.changeVisNew();
                                },
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Password is Empty';
                                  }else if(value.length < 6){
                                    return 'Password incorrect';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                                controller: newCController,
                                label: 'Confirm Password',
                                isPassword: cubit.changePasswordNC,
                                suffix: cubit.changePasswordNC ? Icons.visibility : Icons.visibility_off,
                                suffixPressed: (){
                                  cubit.changeVisNewc();
                                },
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Password is Empty';
                                  }else if(value.length < 6){
                                    return 'Password incorrect';
                                  }else if(value != newController.text){
                                    return 'Password incorrect';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            state is! ChangePasswordLoadingState ?
                            defaultButton(
                              function: (){
                                if(formKeyTow.currentState!.validate()){
                                  cubit.changePassword(
                                    currentPassword: oldController.text,
                                    newPassword:newCController.text ,
                                  );
                                }
                              },
                              text: 'Update Password',
                            ): Center(child: CircularProgressIndicator()),
                          ],
                        ),
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
