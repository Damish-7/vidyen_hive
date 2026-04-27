import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/submission_model.dart';
import '../models/certificate_model.dart';
import '../utils/app_theme.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(SubmissionModelAdapter());
    Hive.registerAdapter(CertificateModelAdapter());

    await Hive.openBox<UserModel>(AppConstants.usersBox);
    await Hive.openBox<SubmissionModel>(AppConstants.submissionsBox);
    await Hive.openBox<CertificateModel>(AppConstants.certificatesBox);
    await Hive.openBox(AppConstants.sessionBox);

    await _seedAdmin();
  }

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> _seedAdmin() async {
    final box = Hive.box<UserModel>(AppConstants.usersBox);
    final existing = box.values.where((u) => u.isAdmin).toList();
    if (existing.isEmpty) {
      final admin = UserModel(
        id: 'admin_001',
        name: 'Conference Admin',
        email: 'admin@vidyen.org',
        passwordHash: hashPassword('Admin@123'),
        regCode: 'ADMIN-001',
        delegateType: 'Administrator',
        designation: 'Conference Director',
        institution: 'VIDYEN Organizing Committee',
        city: 'Mumbai',
        country: 'India',
        phone: '+91-9000000000',
        status: 'approved',
        isAdmin: true,
        createdAt: DateTime.now(),
      );
      await box.put(admin.id, admin);
    }
  }

  // ── USER OPERATIONS ──────────────────────────────────────────
  static Box<UserModel> get usersBox => Hive.box<UserModel>(AppConstants.usersBox);
  static Box<SubmissionModel> get submissionsBox => Hive.box<SubmissionModel>(AppConstants.submissionsBox);
  static Box<CertificateModel> get certificatesBox => Hive.box<CertificateModel>(AppConstants.certificatesBox);
  static Box get sessionBox => Hive.box(AppConstants.sessionBox);

  static Future<UserModel?> login(String email, String password) async {
    final hash = hashPassword(password);
    try {
      return usersBox.values.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.passwordHash == hash,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<bool> register(UserModel user) async {
    final exists = usersBox.values.any(
      (u) => u.email.toLowerCase() == user.email.toLowerCase(),
    );
    if (exists) return false;
    await usersBox.put(user.id, user);
    return true;
  }

  static void saveSession(String userId) {
    sessionBox.put('currentUserId', userId);
  }

  static void clearSession() {
    sessionBox.delete('currentUserId');
  }

  static String? get currentUserId => sessionBox.get('currentUserId');

  static UserModel? get currentUser {
    final id = currentUserId;
    if (id == null) return null;
    return usersBox.get(id);
  }

  static List<UserModel> getAllUsers() {
    return usersBox.values.where((u) => !u.isAdmin).toList();
  }

  static Future<void> updateUserStatus(String userId, String status) async {
    final user = usersBox.get(userId);
    if (user != null) {
      user.status = status;
      await user.save();
    }
  }

  // ── SUBMISSION OPERATIONS ─────────────────────────────────────
  static Future<void> addSubmission(SubmissionModel submission) async {
    await submissionsBox.put(submission.id, submission);
  }

  static List<SubmissionModel> getUserSubmissions(String userId, String type) {
    return submissionsBox.values
        .where((s) => s.userId == userId && s.type == type)
        .toList()
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }

  static List<SubmissionModel> getAllSubmissionsByType(String type) {
    return submissionsBox.values
        .where((s) => s.type == type)
        .toList()
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }

  static Future<void> updateSubmissionStatus(
      String submissionId, String status, String? remark) async {
    final submission = submissionsBox.get(submissionId);
    if (submission != null) {
      submission.status = status;
      submission.adminRemark = remark;
      await submission.save();
    }
  }

  // ── CERTIFICATE OPERATIONS ────────────────────────────────────
  static Future<void> issueCertificate(CertificateModel cert) async {
    await certificatesBox.put(cert.id, cert);
  }

  static List<CertificateModel> getUserCertificates(String userId) {
    return certificatesBox.values
        .where((c) => c.userId == userId)
        .toList()
      ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
  }

  static List<CertificateModel> getAllCertificates() {
    return certificatesBox.values.toList()
      ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
  }
}