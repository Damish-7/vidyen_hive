import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
//import '../utils/app_theme.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  void _checkSession() {
    final user = HiveService.currentUser;
    if (user != null) {
      currentUser.value = user;
    }
  }

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await HiveService.login(email, password);
      if (user != null) {
        currentUser.value = user;
        HiveService.saveSession(user.id);
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String delegateType,
    required String designation,
    required String institution,
    required String city,
    required String country,
    required String phone,
  }) async {
    isLoading.value = true;
    try {
      final uuid = const Uuid().v4();
      final regCode = 'VID-${DateTime.now().year}-${uuid.substring(0, 6).toUpperCase()}';

      final user = UserModel(
        id: uuid,
        name: name,
        email: email,
        passwordHash: HiveService.hashPassword(password),
        regCode: regCode,
        delegateType: delegateType,
        designation: designation,
        institution: institution,
        city: city,
        country: country,
        phone: phone,
        status: 'pending' ,
        isAdmin: false,
        createdAt: DateTime.now(),
      );

      final success = await HiveService.register(user);
      if (success) {
        currentUser.value = user;
        HiveService.saveSession(user.id);
        return null; // success
      }
      return 'Email already registered';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    HiveService.clearSession();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }

  void refreshUser() {
    currentUser.value = HiveService.currentUser;
  }
}