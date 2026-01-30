import 'package:get/get.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    BindingsBuilder.put(()=>ForgotPasswordController());
  }

}
