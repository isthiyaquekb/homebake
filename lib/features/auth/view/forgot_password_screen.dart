import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/features/auth/view_model/auth_view_model.dart';
import 'package:home_bake/widgets/app_text_form_field.dart';
import 'package:home_bake/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Forgot password",actionList: [],),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<AuthViewmodel>(builder: (context, provider, child) => Form(
          key: provider.forgotFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: AppAssets.appLogo,
                child: Image(
                  height: MediaQuery.sizeOf(context).height*0.45,
                  width: MediaQuery.sizeOf(context).width
                  ,image: const AssetImage(AppAssets.appLogo),),
              ),
              Text(
                "Enter your email to reset your password",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 20),
              AppTextFormWidget(isEnabled: true, hint: 'enter your email', inputType: TextInputType.emailAddress, label: 'Email', textController: provider.emailController, maxLines: 1, validator: (validate) {
                if(validate.toString().trim().isEmpty){
                  return 'Please enter an email id';
                }
              },),
              const SizedBox(height: 20),
              Center(child: ElevatedButton(
                onPressed: (){
                 if(provider.forgotFormKey.currentState!.validate()){
                   provider.sendPasswordResetEmail(context,provider.emailController.text);
                 }
                },
                child: Text("Reset Password",),
              ),)
            ],
          ),
        ),),
      ),
    );
  }
}
