import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/screens/contacts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

class ContactController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();

  bool lastSortAscending = true;
  bool lastSortByFirstName = true;

  final RxList<ContactModel> displayedContacts = <ContactModel>[].obs;

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

    lastSortByFirstName = true;
    lastSortAscending = true;

    loadContacts();
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

  void addContact() async {
    try {
      if (formkey.currentState!.validate()) {
        await uploadImageToCloudinary();

        final contact = ContactModel(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
          imageUrl: uploadedImageUrl.value,
        );

        final box = Hive.box<ContactModel>('contacts');
        await box.add(contact);

        // Get.snackbar('Success', 'Contact saved successfully!');

        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        uploadedImageUrl.value = '';
        pickedImage.value = null;
        webImage.value = null;
        fileImage.value = null;
        inItial.value = '';

        sortContacts(lastSortAscending, sortByFirstName: lastSortByFirstName);

        Get.off(const ContactsScreen());

        loadContacts();
      } else {
        Get.snackbar("Error", "Please fill all fields correctly");
      }
    } catch (e) {
      log('Error: $e');
      Get.snackbar('Error', 'Something went wrong');
    }
  }

// ........................Load contact..........................

  void loadContacts() {
    final box = Hive.box<ContactModel>('contacts');
    final contacts = box.values.toList();

    contacts.sort((a, b) {
      String aName = '';
      String bName = '';

      if (lastSortByFirstName) {
        aName = a.firstName.trim().isNotEmpty
            ? a.firstName.trim()
            : a.lastName.trim();
        bName = b.firstName.trim().isNotEmpty
            ? b.firstName.trim()
            : b.lastName.trim();
      } else {
        aName = a.lastName.trim().isNotEmpty
            ? a.lastName.trim()
            : a.firstName.trim();
        bName = b.lastName.trim().isNotEmpty
            ? b.lastName.trim()
            : b.firstName.trim();
      }

      return lastSortAscending
          ? aName.toLowerCase().compareTo(bName.toLowerCase())
          : bName.toLowerCase().compareTo(aName.toLowerCase());
    });

    displayedContacts.value = contacts;
  }

// .....................Sort list contact..........................

  void sortContacts(bool ascending, {bool sortByFirstName = true}) async {
    lastSortAscending = ascending;
    lastSortByFirstName = sortByFirstName;

    final box = Hive.box<ContactModel>('contacts');
    final contacts = box.values.toList();

    contacts.sort((a, b) {
      final aName = sortByFirstName ? a.firstName.trim() : a.lastName.trim();
      final bName = sortByFirstName ? b.firstName.trim() : b.lastName.trim();

      return ascending
          ? aName.toLowerCase().compareTo(bName.toLowerCase())
          : bName.toLowerCase().compareTo(aName.toLowerCase());
    });

    await box.clear();
    for (final contact in contacts) {
      await box.add(contact);
    }

    loadContacts();
  }

//................ Delete all contact list........................

  void deleteAllContacts() async {
    final box = Hive.box<ContactModel>('contacts');
    await box.clear();
    displayedContacts.clear();
  }

  // .....................Pick Image.....................

  final Rx<XFile?> pickedImage = Rx<XFile?>(null);
  final Rx<Uint8List?> webImage = Rx<Uint8List?>(null);
  final Rx<io.File?> fileImage = Rx<io.File?>(null);

  final ImagePicker _picker = ImagePicker();
  final RxString uploadedImageUrl = ''.obs;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image;

      if (kIsWeb) {
        webImage.value = await image.readAsBytes();
        fileImage.value = null;
      } else {
        fileImage.value = io.File(image.path);
        webImage.value = null;
      }
      update();
    }
  }

// .....................Upload Image to Cloudinary.........................

  Future<void> uploadImageToCloudinary() async {
    const cloudName = "dgu8vmtqi";
    const uploadPresent = "flutter_unsigned";

    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    if ((kIsWeb && webImage.value == null) ||
        (!kIsWeb && fileImage.value == null)) {
      return;
    }

    var request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = uploadPresent;

    if (kIsWeb && webImage.value != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        webImage.value!,
        filename: 'upload.png',
        contentType: http_parser.MediaType('image', 'png'),
      ));
    } else if (fileImage.value != null) {
      request.files.add(
          await http.MultipartFile.fromPath('file', fileImage.value!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      uploadedImageUrl.value = data['secure_url'];
      // Get.snackbar('Success', 'Image uploaded!');
    }
  }

//.......................Search bar..........................

  var isSearching = false.obs;
  final searchTextController = TextEditingController();

  void toggleSearch() {
    isSearching.toggle();
    if (!isSearching.value) {
      searchTextController.clear();
      displayedContacts.refresh();
    }
  }

//.........................Search contacts......................
  void filterContacts(String query) {
    final box = Hive.box<ContactModel>('contacts');
    final allContacts = box.values.toList();

    if (query.isEmpty) {
      displayedContacts.value = allContacts;
    } else {
      displayedContacts.value = allContacts.where((contact) {
        final name = '${contact.firstName} ${contact.lastName}'.toLowerCase();
        final phone = contact.phone.toLowerCase();
        return name.contains(query.toLowerCase()) || phone.contains(query);
      }).toList();
    }
  }
}
