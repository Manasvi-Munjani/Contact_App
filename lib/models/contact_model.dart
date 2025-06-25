import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ContactModel {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String imageUrl;

  ContactModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.imageUrl,
  });
}
