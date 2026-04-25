import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

  final Rx<Us


  //login form 
  final identifierController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final RxBool loginPasswordVisible = false.obs;


  @override
  void onInit() {
    super.onInit();
    _loadCachedUser();
  }

  Future<void> _loadCachedUser() async {


   
  
}