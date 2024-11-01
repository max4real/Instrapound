import 'package:flutter/material.dart';
import 'package:instrapound/_common/c_theme_controller.dart';
import 'package:instrapound/modules/auth/sign_up/verification/c_verification_page.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../../../_common/c_datacontroller.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    VerificationController controller = Get.put(VerificationController());
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    Color borderColor = secondary;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Verification',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Enter your\nVerification Code',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    // smsRetriever: smsRetriever,
                    controller: controller.pinController,
                    focusNode: controller.focusNode,
                    keyboardType: TextInputType.number,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    // validator: (value) {
                    //   // return value == '222222' ? null : 'Pin is incorrect';
                    //   return controller.validateCode(value);
                    // },
                    onCompleted: (pin) {
                      // debugPrint('onCompleted: $pin');
                      controller.varifyOTP(pin);
                    },
                    onChanged: (value) {
                      // debugPrint('onChanged: $value');
                    },
                    onTapOutside: (event) => dismissKeyboard(),
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ValueListenableBuilder(
                valueListenable: controller.remainingSeconds,
                builder: (context, value, child) {
                  return Text(
                    controller.formatTime(value),
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  );
                },
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'We send verification code to your email ',
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: controller.strEmail,
                      style: TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: '. You can check your inbox.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'I didn’t received the code?',
                    style: TextStyle(fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.sendCodeAgain();
                    },
                    child: ValueListenableBuilder(
                      valueListenable: controller.xSendAgain,
                      builder: (context, value, child) {
                        return Text(
                          ' Send Again.',
                          style: TextStyle(
                              color: value ? secondary : Colors.black,
                              fontSize: 15),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
