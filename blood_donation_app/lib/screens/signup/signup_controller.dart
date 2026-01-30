import '../../api_core/custom_exception_handler.dart';
import '../../api_services/auth_services.dart';
import '../../utilities/app_exports.dart';
import '../home/home_binding.dart';
import '../home/home_view.dart';

class SignupController extends GetxController {
  final TextEditingController fullNameTFController = TextEditingController();
  final TextEditingController userNameTFController = TextEditingController();
  final TextEditingController emailTFController = TextEditingController();
  final TextEditingController passwordTFController = TextEditingController();
  final TextEditingController confirmPasswordTFController =
      TextEditingController();

  @override
  void dispose() {
    emailTFController.dispose();
    fullNameTFController.dispose();
    userNameTFController.dispose();
    passwordTFController.dispose();
    confirmPasswordTFController.dispose();
    super.dispose();
  }

  static SignupController get to {
    try {
      return Get.find<SignupController>();
    } catch (e) {
      return Get.put(SignupController());
    }
  }

  Future singUp() async {
    try {
      AppGlobals.isLoading(true);
      Map<String, dynamic> data = {
        "email": emailTFController.text,
        "password": passwordTFController.text,
        "userName": userNameTFController.text,
        "name": fullNameTFController.text,
      };
      final res = await AuthServices.signUp(data);
      if (res?.user != null) {
        UserPreferences.loginData = res?.user?.toJson() ?? {};
        UserPreferences.isLogin = true;
        UserPreferences.authToken = res?.accessToken ?? "";
        UserPreferences.userId = res?.user?.id ?? "";
        Get.off(() => HomeView(), binding: HomeBinding());
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  void setDummyValuesToControllers() {
    fullNameTFController.text = "Muhammad Ahsan";
    userNameTFController.text = "ahsansainch";
    emailTFController.text = "ahsan@yopmail.com";
    passwordTFController.text = "1234";
    confirmPasswordTFController.text = "1234";
  }
}
