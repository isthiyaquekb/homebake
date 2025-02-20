import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/features/auth/view_model/auth_view_model.dart';
import 'package:home_bake/widgets/app_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthViewmodel>(builder: (context, authViewModel, child) => SingleChildScrollView(
        child: Form(
          key: authViewModel.signupFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: AppAssets.appLogo,
                child: Image(
                  height: MediaQuery.sizeOf(context).height*0.35,
                  width: MediaQuery.sizeOf(context).width
                  ,image: const AssetImage(AppAssets.appLogo),),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height*0.65,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: authViewModel.signupFirstNameController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                          hintText: 'Enter firstname',
                          hintStyle: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) => authViewModel.firstnameValidator(value.toString().trim()),
                      ),
                      const Spacer(flex: 1,),
                      TextFormField(
                        controller: authViewModel.signupLastNameController,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                          hintText: 'Enter lastname',
                          hintStyle: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) => authViewModel.lastnameValidator(value.toString().trim()),
                      ),
                      const Spacer(flex: 1,),
                      TextFormField(
                        controller: authViewModel.signupEmailController,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                          hintText: 'Enter email',
                          hintStyle: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) => authViewModel.emailValidator(value.toString().trim()),
                      ),
                      const Spacer(flex: 1,),
                      TextFormField(
                        controller: authViewModel.signupPasswordController,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                          hintText: 'Enter password',
                          hintStyle: const TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) => authViewModel.passwordValidator(value.toString().trim()),
                      ),
                      const Spacer(flex: 4,),
                      authViewModel.isLoading
                          ? const CircularProgressIndicator()
                          : AppButton(
                        width: MediaQuery.sizeOf(context).width*0.5,
                        title: 'Signup',
                        onTap: () async{
                          authViewModel.sessionSignup(context);

                          // if (success) {
                          //   Navigator.pushReplacementNamed(context, AppRoutes.home);
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(content: Text("Login Failed")));
                          // }
                        },),
                      const Spacer(flex: 3,),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text: 'Already signed up? ',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, color: Colors.black)),
                            TextSpan(
                                text: 'Login ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.black)),
                          ]),),
                      ),
                      const Spacer(flex: 16,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
