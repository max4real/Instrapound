import 'package:get/get.dart';
import 'package:instrapound/modules/auth/login/v_login.dart';

class GatewayController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initLoad();
  }

  void initLoad() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.to(()=>const LoginPage());
  }
}
