import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

// .....................textField fill.....................
  var isAnyFieldFill = false.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(isCheckField);
    lastNameController.addListener(isCheckField);
    phoneController.addListener(isCheckField);

    firstNameController.addListener(editInitial);
    lastNameController.addListener(editInitial);
  }

  void isCheckField() {
    isAnyFieldFill.value = firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        phoneController.text.isNotEmpty;
  }

  @override
  void onClose() {
    super.onClose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
  }

// .....................Initialize First letter.....................
  var inItial = ''.obs;

  void editInitial() {
    final first = firstNameController.text.trim();
    final last = lastNameController.text.trim();

    if (first.isNotEmpty && last.isNotEmpty) {
      inItial.value = '${first[0].toUpperCase()}${last[0].toUpperCase()}';
    } else if (first.isNotEmpty) {
      inItial.value = first[0].toUpperCase();
    } else if (last.isNotEmpty) {
      inItial.value = last[0].toUpperCase();
    } else {
      inItial.value = '';
    }
  }

// .....................AddContact DONE Button.....................
  final GlobalKey<FormState> formkey = GlobalKey();

  void addContact() {
    try {
      if (formkey.currentState!.validate()) {

      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
