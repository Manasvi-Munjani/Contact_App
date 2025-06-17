import 'package:contact_app/constant/app_color_const.dart';
import 'package:flutter/material.dart';

class AppTextfield extends StatelessWidget {
  final String labelText;

  const AppTextfield({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
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
    );
  }
}

