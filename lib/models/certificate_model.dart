import 'package:hive/hive.dart';

part 'certificate_model.g.dart';

@HiveType(typeId: 2)
class CertificateModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String userName;

  @HiveField(3)
  late String title;

  @HiveField(4)
  late String type; // participation, presentation, workshop

  @HiveField(5)
  late DateTime issuedAt;

  @HiveField(6)
  late String issuedBy;

  @HiveField(7)
  late String? filePath;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.type,
    required this.issuedAt,
    required this.issuedBy,
    this.filePath,
  });
}