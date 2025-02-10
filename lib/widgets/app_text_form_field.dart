import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_colors.dart';

class AppTextFormWidget extends StatelessWidget {
  const AppTextFormWidget({
    super.key,
    required this.isEnabled,
    required this.hint,
    required this.label,
    required this.textController,
    this.icon,
    required this.validator,
    this.onChange,
  });

  final bool isEnabled;
  final String hint;
  final String label;
  final String? icon;
  final TextEditingController textController;
  final String? Function(String?) validator; // Updated to function type
  final String? Function(String?)? onChange; // Updated to function type

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: textController,
        textInputAction: TextInputAction.next,
        style: Theme.of(context).textTheme.bodyMedium,
        enabled: isEnabled,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColor.whiteLight)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColor.whiteLight)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColor.whiteLight)
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColor.darkError)
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColor.darkError)
          ),
          prefixIcon:icon!=null? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset(icon!,colorFilter: const ColorFilter.mode(AppColor.secondaryColor, BlendMode.srcIn),height: 24,width: 24,fit: BoxFit.scaleDown,),
          ):null,
        ),
        validator: validator,
        onChanged: onChange,
      ),
    );
  }
}