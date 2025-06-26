import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/controllers/contact_controller.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

class ContactDetailScreen extends StatelessWidget {
  final ContactModel contactModel;

  const ContactDetailScreen({super.key, required this.contactModel});

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.put(ContactController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Contacts',
                  style: TextStyle(
                      color: AppColorConst.appBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Spacer(),
                Text(
                  'Edit',
                  style: TextStyle(
                      color: AppColorConst.appBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 40,
              child: contactModel.imageUrl.isEmpty
                  ? contactModel.firstName.isNotEmpty &&
                          contactModel.lastName.isNotEmpty
                      ? Text(
                          '${contactModel.firstName[0].toUpperCase()}${contactModel.lastName[0].toUpperCase()}',
                          style: TextStyle(
                              color: AppColorConst.appBlack.withOpacity(0.4),
                              fontWeight: FontWeight.w600,
                              fontSize: 25),
                        )
                      : contactModel.firstName.isNotEmpty
                          ? Text(
                              contactModel.firstName[0].toUpperCase(),
                              style: TextStyle(
                                  color:
                                      AppColorConst.appBlack.withOpacity(0.4),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25),
                            )
                          : contactModel.lastName.isNotEmpty
                              ? Text(
                                  contactModel.lastName[0].toUpperCase(),
                                  style: TextStyle(
                                      color: AppColorConst.appBlack
                                          .withOpacity(0.4),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 24,
                                  color:
                                      AppColorConst.appBlack.withOpacity(0.4),
                                )
                  : null,
            ),
            contactModel.firstName.isNotEmpty &&
                    contactModel.lastName.isNotEmpty
                ? Text(
                    '${contactModel.firstName} ${contactModel.lastName}',
                    style: const TextStyle(
                        color: AppColorConst.appBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                : contactModel.firstName.isNotEmpty
                    ? Text(
                        contactModel.firstName,
                        style: const TextStyle(
                            color: AppColorConst.appBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    : contactModel.lastName.isNotEmpty
                        ? Text(
                            contactModel.lastName,
                            style: const TextStyle(
                                color: AppColorConst.appBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        : const SizedBox(),
            Text(contactModel.phone),
          ],
        ),
      ),
    );
  }
}
