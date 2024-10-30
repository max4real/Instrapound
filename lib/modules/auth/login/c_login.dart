import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../_common/c_datacontroller.dart';

class LoginController extends GetxController {
  DataController dataController = Get.find();
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  ValueNotifier<bool> xObscured = ValueNotifier(true);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void checkAllField() async {
    if (txtEmail.text.isNotEmpty && txtPassword.text.isNotEmpty) {
      // signInWithEmail(txtEmail.text, txtPassword.text);
    } else {
      mySuccessDialog("Enter all field", false);
    }
  }
}
