import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instrapound/modules/auth/sign_up/verification/v_verification_page.dart';
import 'package:local_captcha/local_captcha.dart';

import '../../../../_common/c_datacontroller.dart';

class SignUpCaptchaController extends GetxController {
  LocalCaptchaController localCaptchaController = LocalCaptchaController();

  Timer captchaTimer = Timer(
    const Duration(seconds: 10),
    () {},
  );

  final int _captchaTimerInSecond = 10;

  ValueNotifier<int> captchaRefreshCooldown = ValueNotifier(0);
  ValueNotifier<bool> xValidCaptcha = ValueNotifier(false);

  TextEditingController txtCaptcha = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initLoad();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    captchaTimer.cancel();
  }

  void initLoad() {
    refreshCaptcha();
  }

  void refreshCaptcha() {
    if (captchaRefreshCooldown.value <= 0) {
      localCaptchaController.refresh();
      _resetCaptchaTimer();
    }
  }

  void _resetCaptchaTimer() {
    captchaTimer.cancel();
    captchaRefreshCooldown.value = _captchaTimerInSecond;
    captchaTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        captchaRefreshCooldown.value = _captchaTimerInSecond - timer.tick;
        if (captchaRefreshCooldown.value < 1) {
          timer.cancel();
        }
      },
    );
  }

  Future<void> validateCaptcha() async {
    final query = txtCaptcha.text;
    try {
      final result = localCaptchaController.validate(query);
      if (result == LocalCaptchaValidation.valid) {
        xValidCaptcha.value = true;
        mySuccessDialog(
            "Captcha is valid! Press next to continue", true, Colors.green);
      } else if (result == LocalCaptchaValidation.invalidCode) {
        xValidCaptcha.value = false;
        mySuccessDialog(
            "Captcha is invalid! Please try again!", false, Colors.red);
      } else if (result == LocalCaptchaValidation.codeExpired) {
        xValidCaptcha.value = false;
        mySuccessDialog("Captcha is expired! Please refresh and try again!",
            false, Colors.red);
      }
    } catch (e1) {}
  }

  void onClickNext() {
    Get.to(()=>const VerificationPage());
  }
}
