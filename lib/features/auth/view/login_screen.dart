import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_routes.dart';
import 'package:home_bake/features/auth/view_model/auth_view_model.dart';
import 'package:home_bake/widgets/app_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewmodel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: AppAssets.appLogo,
              child: Image(
                height: MediaQuery.sizeOf(context).height*0.45,
                width: MediaQuery.sizeOf(context).width
                ,image: const AssetImage(AppAssets.appLogo),),
            ),
            Container(
              height: MediaQuery.sizeOf(context).height*0.50,
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
                      controller: authViewModel.emailController,
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
                      controller: authViewModel.passwordController,
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
                    const Spacer(flex: 1,),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password")),
                    const Spacer(flex: 3,),
                    authViewModel.isLoading
                        ? const CircularProgressIndicator()
                        : AppButton(
                      width: MediaQuery.sizeOf(context).width*0.5,
                      title: 'Login',
                      onTap: () async{

                        bool success = await authViewModel.login(
                            authViewModel.emailController.text, authViewModel.passwordController.text);
                        authViewModel.setIsLoading(false);

                        if (success) {
                          Navigator.pushReplacementNamed(context, AppRoutes.home);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login Failed")));
                        }
                      },),
                    const Spacer(flex: 3,),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signUp);
                  },
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, color: Colors.black)),
                      TextSpan(
                          text: 'Signup ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black)),
                      TextSpan(
                          text: 'now.',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, color: Colors.black))
                    ]),),
                ),
                    const Spacer(flex: 16,),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text("Copyright@2025"),
            ),
          ],
        ),
      ),
    );
  }
}
