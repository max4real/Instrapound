import 'dart:async';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instrapound/_common/c_datacontroller.dart';

class VerificationController extends GetxController {
  String strEmail = '';

  TextEditingController pinController = TextEditingController();
  FocusNode focusNode = FocusNode();
  ValueNotifier<int> remainingSeconds = ValueNotifier(60);
  ValueNotifier<bool> xSendAgain = ValueNotifier(false);
  ValueNotifier<bool> xFetching = ValueNotifier(false);

  Timer? timer;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initLoad();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  void initLoad() async {
    DataController dataController = Get.find();

    EmailOTP.config(
      appName: 'Instrapound - Register OTP',
      otpType: OTPType.numeric,
      expiry: 30000,
      emailTheme: EmailTheme.v3,
      appEmail: 'instrapound@gmail.com',
      otpLength: 6,
    );

    startCountdown();
    strEmail = dataController.email;
    print(strEmail);
    // await sendOTP(strEmail);
    // signUpWithEmailandPassword(
    //     dataController.email, dataController.password, dataController.name);
  }

  Future<bool> sendOTP(String email) async {
    bool result = false;
    // if(otpRefreshCooldown.value<=0){
    // _resetOtpTimer();
    try {
      result = await EmailOTP.sendOTP(email: email);
    } catch (e1) {
      print(e1);
    }
    // }
    return result;
  }

  Future<void> signUpWithEmailandPassword(
      String email, String password, String name) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            mySuccessDialog(
                "The email address is already in use.", false, Colors.red);
            break;
          case 'weak-password':
            mySuccessDialog(
                "The password provided is too weak.", false, Colors.red);
            break;
          case 'invalid-email':
            mySuccessDialog(
                "The email address is badly formatted.", false, Colors.red);
            break;
          default:
            mySuccessDialog("Error: ${e.message}", false, Colors.red);
            break;
        }
      } else {
        print("Error: $e");
      }
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        xSendAgain.value = true;
        timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> varifyEmail(String? pin) async {
    // String url = ApiEndpoint.baseUrl2 + ApiEndpoint.authVerifyEmail2;
    // xFetching.value = false;
    // GetConnect client = GetConnect(timeout: const Duration(seconds: 10));
    // try {
    //   Get.dialog(const Center(
    //     child: CircularProgressIndicator(
    //       color: Colors.green,
    //     ),
    //   ));

    //   final response = await client.post(url, {"email": strEmail, "code": pin});

    //   Get.back();
    //   if (response.isOk) {
    //     maxSuccessDialog(
    //         response.body['_metadata']['message'].toString(), true);
    //     Get.offAll(() => const LoginPage());
    //   } else {
    //     maxSuccessDialog(
    //         response.body['_metadata']['message'].toString(), false);
    //   }
    // } catch (e1) {}

    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: '+959789786123',
    //   verificationCompleted: (PhoneAuthCredential credential) {},
    //   verificationFailed: (FirebaseAuthException e) {},
    //   codeSent: (String verificationId, int? resendToken) {},
    //   codeAutoRetrievalTimeout: (String verificationId) {},
    // );

    // await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  void sendCodeAgain() {
    if (xSendAgain.value) {
      xSendAgain.value = false;
      print('send again');
      // sendOTPAgain();
      remainingSeconds.value = 60;
      startCountdown();
    } else {
      print("not now");
    }
  }

  // Future<void> sendOTPAgain() async {
  //   String url = ApiEndpoint.baseUrl2 + ApiEndpoint.authResendOTP2;
  //   xFetching.value = false;
  //   GetConnect client = GetConnect(timeout: const Duration(seconds: 10));
  //   try {
  //     Get.dialog(const Center(child: CircularProgressIndicator()));

  //     final response = await client.post(url, {"email": strEmail});

  //     Get.back();
  //     if (response.isOk) {
  //       maxSuccessDialog(
  //           response.body['_metadata']['message'].toString(), true);
  //     } else {
  //       maxSuccessDialog(
  //           response.body['_metadata']['message'].toString(), false);
  //     }
  //   } catch (e1) {}
  // }
}
