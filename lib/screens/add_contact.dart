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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      contactController.firstNameFocusNode.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColorConst.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: contactController.formkey,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => contactController.pickImage(),
                        child: Obx(
                          () => CircleAvatar(
                            radius: 40,
                            backgroundImage: contactController.webImage.value !=
                                    null
                                ? MemoryImage(contactController.webImage.value!)
                                : contactController.fileImage.value != null
                                    ? FileImage(
                                        contactController.fileImage.value!)
                                    : null,
                            child: (contactController.webImage.value == null &&
                                    contactController.fileImage.value == null)
                                ? (contactController.inItial.value.isNotEmpty
                                    ? Text(
                                        contactController.inItial.value,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColorConst.appBlack
                                              .withOpacity(0.4),
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        color: AppColorConst.appBlack
                                            .withOpacity(0.3),
                                        size: 70,
                                      ))
                                : null,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                controller:
                                    contactController.firstNameController,
                                focusNode: contactController.firstNameFocusNode,
                              ),
                              const SizedBox(height: 13),
                              AppTextfield(
                                labelText: 'Last name',
                                hintText: 'Enter your last name',
                                controller:
                                    contactController.lastNameController,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
