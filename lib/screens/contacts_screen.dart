import 'package:contact_app/constant/app_color_const.dart';
import 'package:contact_app/constant/app_image_const.dart';
import 'package:contact_app/controllers/contact_controller.dart';
import 'package:contact_app/screens/add_contact.dart';
import 'package:contact_app/screens/contact_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          child: child,
                        );
                      },
                      child: contactController.isSearching.value
                          ? TextField(
                              key: const ValueKey(1),
                              controller:
                                  contactController.searchTextController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search contacts...',
                                hintStyle: TextStyle(
                                  color:
                                      AppColorConst.appBlack.withOpacity(0.4),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                contactController.filterContacts(value);
                              },
                            )
                          : const Text(
                              'Contacts',
                              key: ValueKey(2),
                              style: TextStyle(
                                color: AppColorConst.appBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      contactController.isSearching.value
                          ? Icons.close
                          : Icons.search,
                      size: 24,
                    ),
                    onPressed: () {
                      contactController.toggleSearch();
                    },
                  ),
                  const SizedBox(width: 5),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_rounded, size: 24),
                    onSelected: (value) {
                      if (value == 'Sort by') {
                      } else if (value == 'Delete all') {}
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: GestureDetector(
                          onTapDown: (details) async {
                            Navigator.pop(context);
                            // Get.back();
                            final position = details.globalPosition;

                            final selected = await showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                  position.dx, position.dy, 0, 0),
                              items: [
                                const PopupMenuItem(
                                  value: 'A-Z',
                                  child: Text('A-Z'),
                                ),
                                const PopupMenuItem(
                                  value: 'Z-A',
                                  child: Text('Z-A'),
                                ),
                              ],
                            );

                            if (selected == 'A-Z') {
                              contactController.sortContacts(true);
                            } else if (selected == 'Z-A') {
                              contactController.sortContacts(false);
                            }
                          },
                          child: const Row(
                            children: [
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
                      PopupMenuItem(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();

                            Get.defaultDialog(
                              title: "Confirm Delete",
                              titleStyle: const TextStyle(
                                color: AppColorConst.appBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              middleText:
                                  "Are you sure you want to delete \nall contacts?",
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
                                contactController.deleteAllContacts();
                                Get.back();
                              },
                              onCancel: () {},
                            );
                          },
                          child: const Text(
                            'Delete all',
                            style: TextStyle(
                                color: AppColorConst.appBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }),
            Expanded(
              child: Obx(() {
                final contacts = contactController.displayedContacts;

                if (contacts.isEmpty) {
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
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return GestureDetector(
                      onTap: () => Get.off(() => ContactDetailScreen(
                            contactModel: contact,
                            index: index,
                          )),
                      child: Container(
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
                              backgroundImage: contacts.isNotEmpty &&
                                      contact.imageUrl.isNotEmpty
                                  ? NetworkImage(contact.imageUrl)
                                      as ImageProvider
                                  : null,
                              child: contacts.isEmpty ||
                                      contact.imageUrl.isEmpty
                                  ? contact.firstName.isNotEmpty &&
                                          contact.lastName.isNotEmpty
                                      ? Text(
                                          '${contact.firstName[0].toUpperCase()}${contact.lastName[0].toUpperCase()}',
                                          style: TextStyle(
                                              color: AppColorConst.appBlack
                                                  .withOpacity(0.4),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        )
                                      : contact.firstName.isNotEmpty
                                          ? Text(
                                              contact.firstName[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: AppColorConst.appBlack
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          : contact.lastName.isNotEmpty
                                              ? Text(
                                                  contact.lastName[0]
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: AppColorConst
                                                          .appBlack
                                                          .withOpacity(0.4),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  size: 24,
                                                  color: AppColorConst.appBlack
                                                      .withOpacity(0.4),
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
                      ),
                    );
                  },
                );
              }),
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
