import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/submission_model.dart';
import '../models/certificate_model.dart';
import '../services/hive_service.dart';
import 'auth_controller.dart';

class SubmissionController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  final RxList<SubmissionModel> abstracts = <SubmissionModel>[].obs;
  final RxList<SubmissionModel> preconfs = <SubmissionModel>[].obs;
  final RxList<SubmissionModel> workshops = <SubmissionModel>[].obs;
  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;

  // Admin: all submissions
  final RxList<SubmissionModel> allAbstracts = <SubmissionModel>[].obs;
  final RxList<SubmissionModel> allPreconfs = <SubmissionModel>[].obs;
  final RxList<SubmissionModel> allWorkshops = <SubmissionModel>[].obs;
  final RxList<CertificateModel> allCertificates = <CertificateModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  void loadAll() {
    final user = _auth.currentUser.value;
    if (user == null) return;

    if (user.isAdmin) {
      allAbstracts.value = HiveService.getAllSubmissionsByType('abstract');
      allPreconfs.value = HiveService.getAllSubmissionsByType('preconf');
      allWorkshops.value = HiveService.getAllSubmissionsByType('workshop');
      allCertificates.value = HiveService.getAllCertificates();
    } else {
      abstracts.value = HiveService.getUserSubmissions(user.id, 'abstract');
      preconfs.value = HiveService.getUserSubmissions(user.id, 'preconf');
      workshops.value = HiveService.getUserSubmissions(user.id, 'workshop');
      certificates.value = HiveService.getUserCertificates(user.id);
    }
  }

  Future<void> submitAbstract({
    required String title,
    required String description,
    String? coAuthors,
    String? keywords,
    String? category,
    String? filePath,
  }) async {
    final user = _auth.currentUser.value!;
    isLoading.value = true;
    try {
      final submission = SubmissionModel(
        id: const Uuid().v4(),
        userId: user.id,
        userName: user.name,
        type: 'abstract',
        title: title,
        description: description,
        coAuthors: coAuthors,
        keywords: keywords,
        category: category,
        filePath: filePath,
        submittedAt: DateTime.now(),
      );
      await HiveService.addSubmission(submission);
      loadAll();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitPreconf({
    required String title,
    required String description,
    String? coAuthors,
    String? keywords,
    String? category,
    String? filePath,
  }) async {
    final user = _auth.currentUser.value!;
    isLoading.value = true;
    try {
      final submission = SubmissionModel(
        id: const Uuid().v4(),
        userId: user.id,
        userName: user.name,
        type: 'preconf',
        title: title,
        description: description,
        coAuthors: coAuthors,
        keywords: keywords,
        category: category,
        filePath: filePath,
        submittedAt: DateTime.now(),
      );
      await HiveService.addSubmission(submission);
      loadAll();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitWorkshop({
    required String title,
    required String description,
    String? coAuthors,
    String? category,
    String? filePath,
  }) async {
    final user = _auth.currentUser.value!;
    isLoading.value = true;
    try {
      final submission = SubmissionModel(
        id: const Uuid().v4(),
        userId: user.id,
        userName: user.name,
        type: 'workshop',
        title: title,
        description: description,
        coAuthors: coAuthors,
        category: category,
        filePath: filePath,
        submittedAt: DateTime.now(),
      );
      await HiveService.addSubmission(submission);
      loadAll();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String submissionId, String status, String? remark) async {
    await HiveService.updateSubmissionStatus(submissionId, status, remark);
    loadAll();
  }

  Future<void> issueCertificate({
    required String userId,
    required String userName,
    required String title,
    required String type,
  }) async {
    final cert = CertificateModel(
      id: const Uuid().v4(),
      userId: userId,
      userName: userName,
      title: title,
      type: type,
      issuedAt: DateTime.now(),
      issuedBy: _auth.currentUser.value?.name ?? 'Admin',
    );
    await HiveService.issueCertificate(cert);
    loadAll();
  }

  int get totalSubmissions =>
      abstracts.length + preconfs.length + workshops.length;

  int get approvedCount => [
        ...abstracts,
        ...preconfs,
        ...workshops,
      ].where((s) => s.status == 'approved').length;
}