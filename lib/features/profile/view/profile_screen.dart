import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_assets.dart';
import 'package:home_bake/core/app_colors.dart';
import 'package:home_bake/features/auth/model/user_model.dart';
import 'package:home_bake/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:home_bake/utils/date_formatter.dart';
import 'package:home_bake/widgets/app_text_form_field.dart';
import 'package:home_bake/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      final profileViewmodel = Provider.of<ProfileViewmodel>(context, listen: false);
      profileViewmodel.onInit();
    });
    return Scaffold(
      appBar: CommonAppBar(title: 'Profile', actionList: [
        Consumer<ProfileViewmodel>(builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: (){
              provider.enableEdit(!provider.isEnabled);
            },
              child: SvgPicture.asset(provider.isEnabled?AppAssets.cross:AppAssets.editIcon)),
        ),)
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ProfileViewmodel>(builder: (context, provider, child) {
            if (provider.userId.isEmpty) {
              return const Center(child: Text("User ID is missing"));
            }

            return StreamBuilder(stream: provider.getUserDetail(provider.userId),builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("No Profile Data Found"));
              }
              UserModel user = snapshot.data!;
              provider.setProfileData(user);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: provider.isEnabled?Colors.green.shade200:Colors.amber.shade200,
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: const Image(image: AssetImage(AppAssets.dummyProfile),)),
                      ),
                    ),
                  ),
                  !provider.isEnabled?Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(child: SvgPicture.asset(provider.selectedGenderIndex==0?AppAssets.male:AppAssets.female,height: 24,width: 24,)),
                  ):const SizedBox.shrink(),
                  Consumer<ProfileViewmodel>(builder: (context, provider, child) => Container(
                    width: double.maxFinite,decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 12),
                      child: Form(
                        key: provider.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextFormWidget(
                              hint: "First name",
                              label: "First name",
                              inputType: TextInputType.name,
                              isEnabled: provider.isEnabled,
                              maxLines: 1,
                              validator: (p0) {

                              },
                              textController: provider.firstController,
                              icon: AppAssets.userProfile,
                              onChange: (p0) {

                              },
                            ),
                            AppTextFormWidget(
                              hint: "Last name",
                              label: "Last name",
                              inputType: TextInputType.name,
                              isEnabled: provider.isEnabled,
                              maxLines: 1,
                              validator: (p0) {

                              },
                              textController: provider.lastController,
                              icon: AppAssets.userProfile,
                              onChange: (p0) {

                              },
                            ),
                            AppTextFormWidget(
                              hint: "Email",
                              label: "Email",
                              inputType: TextInputType.emailAddress,
                              isEnabled: provider.isEnabled,
                              maxLines: 1,
                              validator: (p0) {

                              },
                              textController: provider.emailController,
                              icon: AppAssets.email,
                              onChange: (p0) {

                              },
                            ),
                            AppTextFormWidget(
                              hint: "Phone",
                              label: "Phone",
                              inputType: TextInputType.phone,
                              isEnabled: provider.isEnabled,
                              maxLines: 1,
                              validator: (p0) {

                              },
                              textController: provider.phoneController,
                              icon: AppAssets.phone,
                              onChange: (p0) {

                              },
                            ),
                            AppTextFormWidget(
                              hint: "Address",
                              label: "Address",
                              inputType: TextInputType.text,
                              isEnabled: provider.isEnabled,
                              maxLines: 1,
                              validator: (p0) {

                              },
                              textController: provider.addressController,
                              icon: AppAssets.address,
                              onChange: (p0) {

                              },
                            ),
                            InkWell(
                              onTap: ()async{
                                log("SHOW CALENDER");
                                provider.isEnabled?provider.dobPicker(context):null;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(height: 46,width: MediaQuery.sizeOf(context).width,decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color:  AppColor.whiteLight)
                                ),child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.calender,height: 24,width: 24,colorFilter: ColorFilter.mode(provider.isEnabled?Colors.green:Colors.red, BlendMode.srcIn),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(DateFormatter.formatDDYYMM(provider.birthdate),style: Theme.of(context).textTheme.bodyMedium,),
                                      )
                                    ],
                                  ),
                                ),),
                              ),
                            ),

                            provider.isEnabled?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: provider.genderList.map((genderElement) => InkWell(
                                onTap: (){
                                  provider.setGenderIndex(provider.genderList.indexOf(genderElement));
                                },
                                child: Container(
                                    height: 40,
                                    width: MediaQuery.sizeOf(context).width*0.4,
                                    decoration: BoxDecoration(
                                        color: provider.genderList.indexOf(genderElement)==provider.selectedGenderIndex?AppColor.primaryColor.withOpacity(0.5):Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColor.borderColor)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: SvgPicture.asset(genderElement.icon,height: 24,width: 24,)),
                                    )),
                              ),).toList(),):const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),),

                  provider.isEnabled?Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.2),
                    child: ElevatedButton(
                      onPressed: () {

                        Provider.of<ProfileViewmodel>(context,listen: false).updateSession();
                        // context.read<DashboardViewmodel>().setCurrentIndex(1);
                        // Navigator.pushReplacementNamed(context, AppRoutes.success);
                      },
                      child: const Center(
                        child: Text("Update"),
                      ),
                    ),
                  ):const SizedBox.shrink()
                ],
              );
            },);
          },)
        ),
      ),
    );
  }
}
