import 'dart:async';
import 'forgot_password_binding.dart';
import '../../utilities/app_exports.dart';
import '../../api_services/auth_services.dart';
import '../../api_core/custom_exception_handler.dart';
import '/screens/forgot-password/views/verify_code_view.dart';
import '/screens/forgot-password/views/reset_password_view.dart';
import '/screens/forgot-password/views/reset_password_success_view.dart';

class ForgotPasswordController extends GetxController {
  final emailTFController = TextEditingController();
  final otpTFController = TextEditingController();
  final passwordTFController = TextEditingController();
  final confirmPasswordTFController = TextEditingController();

  static ForgotPasswordController get to {
    try {
      return Get.find<ForgotPasswordController>();
    } catch (e) {
      return Get.put(ForgotPasswordController());
    }
  }

  var otp = ''.obs; // For storing the OTP value
  var timerSeconds = 600.obs; // Timer for countdown
  Timer? _timer;

  // Starts the countdown timer
  void startTimer() {
    timerSeconds.value = 600;
    if (_timer != null) _timer!.cancel(); // Cancel previous timer if any
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel(); // Cancel timer when it hits 0
      }
    });
  }

  // Resends the OTP and resets the timer
  void resendOtp(Map<String, dynamic> reqBody) async {
    try {
      AppGlobals.isLoading(true);
      final res = await AuthServices.sendOTP({"email": emailTFController.text});
      if (res != null) {
        otpTFController.clear();
        startTimer();
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future sendOTP() async {
    try {
      AppGlobals.isLoading(true);
      final res = await AuthServices.sendOTP({"email": emailTFController.text});
      if (res != null) {
        Get.to(
          () => VerifyCodeView(email: emailTFController.text),
          binding: ForgotPasswordBinding(),
        );
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future verifyOtp() async {
    try {
      AppGlobals.isLoading(true);
      final res = await AuthServices.verifyOTP({
        "email": emailTFController.text,
        "otp": int.parse(otpTFController.text),
      });
      if (res != null) {
        Get.to(() => ResetPasswordView(), binding: ForgotPasswordBinding());
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future resetPassword() async {
    try {
      AppGlobals.isLoading(true);
      final res = await AuthServices.resetPassword({
        "email": emailTFController.text,
        "newPassword": passwordTFController.text,
      });
      if (res != null) {
        Get.to(() => ResetPasswordSuccessView());
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer!.cancel(); // Clean up timer
    emailTFController.dispose();
    otpTFController.dispose();
    passwordTFController.dispose();
    confirmPasswordTFController.dispose();
  }
}
