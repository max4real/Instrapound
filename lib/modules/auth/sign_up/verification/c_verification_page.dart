import 'dart:async';

import 'package:email_otp/email_otp.dart';
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
      expiry: 60000,
      emailTheme: EmailTheme.v3,
      appEmail: 'instrapound@gmail.com',
      otpLength: 6,
    );

    // EmailOTP.setTemplate(
    //   template: '''
    // <div style="background-color: #f4f4f4; padding: 20px; font-family: Arial, sans-serif;">
    //   <div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
    //     <h1 style="color: #333;">{{appName}}</h1>
    //     <p style="color: #333;">Your OTP is <strong>{{otp}}</strong></p>
    //     <p style="color: #333;">This OTP is valid for 1 minutes.</p>
    //     <p style="color: #333;">Thank you for using our service.</p>
    //   </div>
    // </div>
    // ''',
    // );

    strEmail = dataController.email;
    print(strEmail);
    await sendOTP(strEmail);
  }

  Future<bool> sendOTP(String email) async {
    bool result = false;
    startCountdown();

    try {
      result = await EmailOTP.sendOTP(email: email);
    } catch (e1) {
      print(e1);
    }
    return result;
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

  Future<void> varifyOTP(String pin) async {
    bool result = false;
    try {
      result = EmailOTP.verifyOTP(otp: pin);
    } catch (e1) {
      print(e1);
    }
    if (result) {
      myMessageDialog("OTP True");
    } else {
      myMessageDialog("OTP False");
    }
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
  }

  void sendCodeAgain() {
    if (xSendAgain.value) {
      xSendAgain.value = false;
      print('send again');
      sendOTP(strEmail);
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
