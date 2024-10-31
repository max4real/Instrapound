import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instrapound/modules/auth/captcha/v_captcha.dart';

import '../../../_common/c_datacontroller.dart';

class SignUpController extends GetxController {
  DataController dataController = Get.find();
  TextEditingController txtName = TextEditingController(text: "");
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");

  ValueNotifier<bool> xObscured = ValueNotifier(true);
  ValueNotifier<bool> xScoreLoading = ValueNotifier(false);

  ValueNotifier<String> score = ValueNotifier('Weak');

  ValueNotifier<bool> xValidEmail = ValueNotifier(false);
  ValueNotifier<bool> xhasUppercase = ValueNotifier(false);
  ValueNotifier<bool> xhasLowercase = ValueNotifier(false);
  ValueNotifier<bool> xhasDigits = ValueNotifier(false);
  ValueNotifier<bool> xhasSpecialCharacters = ValueNotifier(false);
  ValueNotifier<bool> xhasMinLength = ValueNotifier(false);
  ValueNotifier<bool> xvalidScore = ValueNotifier(false);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void initLoad() {}

  void checkAllField() async {
    if (txtEmail.text.isNotEmpty &&
        txtPassword.text.isNotEmpty &&
        txtName.text.isNotEmpty) {
      if (xValidEmail.value) {
        String message = dataController.getFeedbackMessage(txtPassword.text);
        if (message == 'ok') {
          dataController.name = txtName.text;
          dataController.email = txtName.text;
          dataController.password = txtName.text;
          Get.to(() => const CaptchaPage());
        } else {
          mySuccessDialog(message, false, Colors.red);
        }
      } else {
        mySuccessDialog("Enter Valid Email", false, Colors.red);
      }
    } else {
      mySuccessDialog("Enter all field", false, Colors.red);
    }
  }

  void checkEmailOnChange() {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    final value = txtEmail.text;
    if (value.isEmpty || !regex.hasMatch(value)) {
      xValidEmail.value = false;
    } else {
      xValidEmail.value = true;
    }
  }

  void checkPassowrdOnChange() async {
    checkPasswordStrength(txtPassword.text);
    checkPassowrdScore(txtPassword.text);
  }

  void checkPasswordStrength(String password) {
    // Define the criteria
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'\d'));
    final bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final bool hasMinLength = password.length >= 8;

    if (hasUppercase) {
      xhasUppercase.value = true;
    } else {
      xhasUppercase.value = false;
    }
    if (hasLowercase) {
      xhasLowercase.value = true;
    } else {
      xhasLowercase.value = false;
    }
    if (hasDigits) {
      xhasDigits.value = true;
    } else {
      xhasDigits.value = false;
    }
    if (hasSpecialCharacters) {
      xhasSpecialCharacters.value = true;
    } else {
      xhasSpecialCharacters.value = false;
    }
    if (hasMinLength) {
      xhasMinLength.value = true;
    } else {
      xhasMinLength.value = false;
    }
  }

  void checkPassowrdScore(String password) async {
    xScoreLoading.value = true;
    if (password.isNotEmpty) {
      String result = await dataController.checkPassowrdScore(password);
      if (result == '0.0') {
        score.value = 'Weak';
        xvalidScore.value = false;
      } else if (result == '1.0') {
        score.value = 'Fair';
        xvalidScore.value = true;
      } else if (result == '2.0') {
        score.value = 'Strong';
        xvalidScore.value = true;
      } else {
        score.value = 'Weak';
        xvalidScore.value = false;
      }
    }
    xScoreLoading.value = false;
  }
}
