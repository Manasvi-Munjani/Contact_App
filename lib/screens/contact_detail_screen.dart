import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/controllers/contact_controller.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/screens/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

class ContactDetailScreen extends StatelessWidget {
  final ContactModel contactModel;
  final int index;

  const ContactDetailScreen(
      {super.key, required this.contactModel, required this.index});

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.put(ContactController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.off(() => const ContactsScreen()),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColorConst.appBlue,
                    size: 20,
                  ),
                ),
                const Text(
                  'Contacts',
                  style: TextStyle(
                    color: AppColorConst.appBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Text(
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
              backgroundImage: contactModel.imageUrl.isNotEmpty
                  ? NetworkImage(contactModel.imageUrl) as ImageProvider
                  : null,
              child: contactModel.imageUrl.isEmpty
                  ? contactModel.firstName.isNotEmpty &&
                          contactModel.lastName.isNotEmpty
                      ? Text(
                          '${contactModel.firstName[0].toUpperCase()}${contactModel.lastName[0].toUpperCase()}',
                          style: TextStyle(
                            color: AppColorConst.appBlack.withOpacity(0.4),
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        )
                      : contactModel.firstName.isNotEmpty
                          ? Text(
                              contactModel.firstName[0].toUpperCase(),
                              style: TextStyle(
                                color: AppColorConst.appBlack.withOpacity(0.4),
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              ),
                            )
                          : contactModel.lastName.isNotEmpty
                              ? Text(
                                  contactModel.lastName[0].toUpperCase(),
                                  style: TextStyle(
                                    color:
                                        AppColorConst.appBlack.withOpacity(0.4),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 24,
                                  color:
                                      AppColorConst.appBlack.withOpacity(0.4),
                                )
                  : null,
            ),
            const SizedBox(height: 10),
            contactModel.firstName.isNotEmpty &&
                    contactModel.lastName.isNotEmpty
                ? Text(
                    '${contactModel.firstName} ${contactModel.lastName}',
                    style: const TextStyle(
                      color: AppColorConst.appBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : contactModel.firstName.isNotEmpty
                    ? Text(
                        contactModel.firstName,
                        style: const TextStyle(
                          color: AppColorConst.appBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : contactModel.lastName.isNotEmpty
                        ? Text(
                            contactModel.lastName,
                            style: const TextStyle(
                              color: AppColorConst.appBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const SizedBox(),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contactModel.phone,
                  style: const TextStyle(
                    color: AppColorConst.appBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColorConst.appGreen,
                  child: Icon(
                    Icons.phone,
                    color: AppColorConst.appWhite,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColorConst.appYellow,
                  child: Icon(
                    Icons.sms,
                    color: AppColorConst.appWhite,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Get.defaultDialog(
                    title: "Confirm Delete",
                    titleStyle: TextStyle(
                      color: AppColorConst.appBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    middleText:
                        "Are you sure you want to delete \nthis contacts?",
                    middleTextStyle: TextStyle(
                      color: AppColorConst.appBlack.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: AppColorConst.appWhite,
                    buttonColor: AppColorConst.appGreen,
                    onConfirm: () {
                      final box = Hive.box<ContactModel>('contacts');

                      box.deleteAt(index);
                      Get.back();
                      Get.off(() => const ContactsScreen());
                      contactController.loadContacts();
                    },
                    onCancel: () {},
                  ),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColorConst.appRed,
                    child: Icon(
                      Icons.delete,
                      color: AppColorConst.appWhite,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
