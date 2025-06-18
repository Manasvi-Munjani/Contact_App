import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/constant/app_image_const.dart';
import 'package:contact_app/screens/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.search, size: 24),
                SizedBox(width: 5),
                Icon(Icons.more_vert_rounded, size: 24)
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImageConst.appEmptyImage,
                    height: 80,
                    width: 80,
                  ),
                  Text(
                    'You have no contacts yet',
                    style: TextStyle(
                      color: AppColorConst.appBlack.withOpacity(0.4),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddContact()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
