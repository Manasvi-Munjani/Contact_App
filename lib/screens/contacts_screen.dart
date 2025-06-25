import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/constant/app_image_const.dart';
import 'package:contact_app/controllers/contact_controller.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/screens/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.put(ContactController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Contacts',
                  style: TextStyle(
                      color: AppColorConst.appBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                const Spacer(),
                const Icon(Icons.search, size: 24),
                const SizedBox(width: 5),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_rounded, size: 24),
                  onSelected: (value) {
                    if (value == 'Sort by') {
                    } else if (value == 'Delete all') {}
                  },
                  itemBuilder: (context) => [
                /*    const PopupMenuItem(
                      value: 'Sort by',
                      child: Row(
                        children: [
                          Text(
                            'Sort by',
                            style: TextStyle(
                                color: AppColorConst.appBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_right, size: 22),
                        ],
                      ),
                    ),*/

                    PopupMenuItem(
                      child: GestureDetector(
                        onTapDown: (details) async {
                          Navigator.pop(context); // close main menu
                          final position = details.globalPosition;

                          final selected = await showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
                            items: [
                              PopupMenuItem(
                                value: 'A-Z',
                                child: Text('A-Z'),
                              ),
                              PopupMenuItem(
                                value: 'Z-A',
                                child: Text('Z-A'),
                              ),
                            ],
                          );

                          if (selected == 'A-Z') {
                            final box = Hive.box<ContactModel>('contacts');
                           contactController.sortContacts(box, true);
                          } else if (selected == 'Z-A') {
                            final box = Hive.box<ContactModel>('contacts');
                           contactController.sortContacts(box, false);
                          }
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Sort by',
                              style: TextStyle(
                                color: AppColorConst.appBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_right, size: 22),
                          ],
                        ),
                      ),
                    ),



                    const PopupMenuItem(
                      child: Text(
                        'Delete all',
                        style: TextStyle(
                            color: AppColorConst.appBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<ContactModel>('contacts').listenable(),
                builder: (context, Box<ContactModel> box, _) {
                  if (box.isEmpty) {
                    return Center(
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
                    );
                  }

                  return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final contact = box.getAt(index)!;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColorConst.appWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: box.isNotEmpty &&
                                        contact.imageUrl.isNotEmpty
                                    ? NetworkImage(contact.imageUrl)
                                        as ImageProvider
                                    : null,
                                child: box.isEmpty || contact.imageUrl.isEmpty
                                    ? Text(
                                        '${contact.firstName[0].toUpperCase()}${contact.lastName[0].toUpperCase()}',
                                        style: TextStyle(
                                            color: AppColorConst.appBlack
                                                .withOpacity(0.4),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${contact.firstName} ${contact.lastName}',
                                    style: const TextStyle(
                                        color: AppColorConst.appBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    contact.phone,
                                    style: const TextStyle(
                                        color: AppColorConst.appBlack,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.phone,
                                color: AppColorConst.appGreen,
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: SizedBox(
          height: 43,
          width: 43,
          child: FloatingActionButton(
            onPressed: () => Get.to(() => const AddContact()),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
