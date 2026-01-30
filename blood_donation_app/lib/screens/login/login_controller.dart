import '../home/home_view.dart';
import '../home/home_binding.dart';
import '../../utilities/app_exports.dart';
import '../../api_services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../api_core/custom_exception_handler.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn= GoogleSignIn();
  final TextEditingController emailTFController = TextEditingController();
  final TextEditingController passwordTFController = TextEditingController();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      emailTFController.text=user?.email??'';
      log('Full Name :${user?.displayName}');
      log('User Name :${user?.displayName.removeAllWhiteSpaces.toLowerCase()}');
      log('Email :${user?.email}');
      log('Email :${user?.photoURL}');
    } catch (e) {
      log('Error: ${e.toString()}');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get user => _auth.currentUser;
  @override
  void dispose() {
    emailTFController.dispose();
    passwordTFController.dispose();
    super.dispose();
  }

  static LoginController get to {
    try {
      return Get.find<LoginController>();
    } catch (e) {
      return Get.put(LoginController());
    }
  }

  Future logIn() async {
    try {
      AppGlobals.isLoading(true);
      Map<String, dynamic> data = {
        "email": emailTFController.text,
        "password": passwordTFController.text,
      };
      final res = await AuthServices.loginIn(data);
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
}
