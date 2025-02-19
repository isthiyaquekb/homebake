import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_bake/core/app_colors.dart';

class AppTextFormWidget extends StatelessWidget {
  const AppTextFormWidget({
    super.key,
    required this.isEnabled,
    required this.hint,
    required this.inputType,
    required this.label,
    required this.textController,
    required this.maxLines,
    this.icon,
    required this.validator,
    this.onChange,
  });

  final bool isEnabled;
  final String hint;
  final TextInputType inputType;
  final String label;
  final String? icon;
  final TextEditingController textController;
  final int maxLines;
  final String? Function(String?) validator; // Updated to function type
  final String? Function(String?)? onChange; // Updated to function type

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: textController,
        textInputAction: TextInputAction.next,
        keyboardType: inputType,
        style: Theme.of(context).textTheme.bodyMedium,
        enabled: isEnabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          labelText: label,
          labelStyle: textController.text.isNotEmpty?Theme.of(context).textTheme.bodyMedium:Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColor.inActiveColor.withOpacity(0.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: textController.text.isNotEmpty?AppColor.whiteLight:AppColor.inActiveColor.withOpacity(0.5))
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: textController.text.isNotEmpty?AppColor.whiteLight:AppColor.inActiveColor.withOpacity(0.5))
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppColor.primaryColor)
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
            child: SvgPicture.asset(icon!,colorFilter: ColorFilter.mode(isEnabled?AppColor.primaryColor:AppColor.secondaryColor, BlendMode.srcIn),height: 24,width: 24,fit: BoxFit.scaleDown,),
          ):null,
        ),
        validator: validator,
        onChanged: onChange,
      ),
    );
  }
}