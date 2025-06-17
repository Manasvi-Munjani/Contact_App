import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/controllers/contact_controller.dart';
import 'package:contact_app/validations/app_validation.dart';
import 'package:contact_app/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContact extends StatelessWidget {
  const AddContact({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.put(ContactController());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cancel',
              style: TextStyle(
                color: AppColorConst.appBlue,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const Text(
              'New Contact',
              style: TextStyle(
                color: AppColorConst.appBlack,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: () => contactController.addContact(),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: contactController.isAnyFieldFill.value
                        ? AppColorConst.appBlue
                        : AppColorConst.appBlack.withOpacity(0.3),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 40,
                  child: contactController.inItial.value.isEmpty
                      ?  Icon(
                          Icons.person,
                          color: AppColorConst.appBlack.withOpacity(0.3),
                          size: 70,
                        )
                      : Text(
                          contactController.inItial.value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColorConst.appBlack.withOpacity(0.4),
                          ),
                        ),
                ),
              ),
              const Text(
                'Add Photo',
                style: TextStyle(
                  color: AppColorConst.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              AppTextfield(
                labelText: 'First name',
                hintText: 'Enter your first name',
                controller: contactController.firstNameController,
              ),
              const SizedBox(height: 13),
              AppTextfield(
                labelText: 'Last name',
                hintText: 'Enter your last name',
                controller: contactController.lastNameController,
              ),
              const SizedBox(height: 13),
              AppTextfield(
                labelText: 'Phone',
                hintText: '+91 90123 45132',
                controller: contactController.phoneController,
                validator: phoneValidation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
