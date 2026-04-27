import 'package:hive/hive.dart';

part 'submission_model.g.dart';

@HiveType(typeId: 1)
class SubmissionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String userName;

  @HiveField(3)
  late String type; // abstract, preconf, workshop

  @HiveField(4)
  late String title;

  @HiveField(5)
  late String description;

  @HiveField(6)
  late String? filePath;

  @HiveField(7)
  late String status; // pending, approved, rejected

  @HiveField(8)
  late String? adminRemark;

  @HiveField(9)
  late DateTime submittedAt;

  @HiveField(10)
  late String? coAuthors;

  @HiveField(11)
  late String? keywords;

  @HiveField(12)
  late String? category;

  SubmissionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.title,
    required this.description,
    this.filePath,
    this.status = 'pending',
    this.adminRemark,
    required this.submittedAt,
    this.coAuthors,
    this.keywords,
    this.category,
  });
}