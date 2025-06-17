import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class AddContact extends StatelessWidget {
  const AddContact({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: CircleAvatar(
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          Text(
            'Add Photo',
            style: TextStyle(
              color: AppColorConst.appBlue,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 30),
          AppTextfield(labelText: 'First name'),
          SizedBox(height: 13),
          AppTextfield(labelText: 'Last name'),
          SizedBox(height: 13),
          AppTextfield(labelText: 'Phone')
        ],
      ),
    );
  }
}
