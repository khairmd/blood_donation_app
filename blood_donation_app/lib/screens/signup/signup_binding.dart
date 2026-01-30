import 'package:get/get.dart';

import 'signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    BindingsBuilder.put(() => SignupController());
  }
}
