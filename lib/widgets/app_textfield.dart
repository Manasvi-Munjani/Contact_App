import 'package:contact_app/constant/app_color_const.dart';
import 'package:flutter/material.dart';

class AppTextfield extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AppTextfield({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: AppColorConst.appBlack.withOpacity(0.7),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColorConst.appBlack.withOpacity(0.4),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColorConst.appBlack.withOpacity(0.4),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        focusColor: AppColorConst.appBlack.withOpacity(0.4),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColorConst.appBlack.withOpacity(0.4),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColorConst.appBlack.withOpacity(0.4),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
