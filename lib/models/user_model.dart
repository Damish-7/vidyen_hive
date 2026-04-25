import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String passwordHash;

  @HiveField(4)
  late String regCode;

  @HiveField(5)
  late String delegateType;

  @HiveField(6)
  late String designation;

  @HiveField(7)
  late String institution;

  @HiveField(8)
  late String city;

  @HiveField(9)
  late String country;

  @HiveField(10)
  late String phone;

  @HiveField(11)
  late String status; // pending, approved, rejected

  @HiveField(12)
  late bool isAdmin;

  @HiveField(13)
  late DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.regCode,
    required this.delegateType,
    required this.designation,
    required this.institution,
    required this.city,
    required this.country,
    required this.phone,
    this.status = 'pending',
    this.isAdmin = false,
    required this.createdAt,
  });
}