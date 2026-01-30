import 'dart:async';
import '../models/auth_model.dart';
import '/screens/home/home_view.dart';
import '../utilities/app_exports.dart';
import '/screens/home/home_binding.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool selected = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (UserPreferences.isLogin == true) {
        AuthModel.fromJson({
          "status": true,
          "code": "SUCCESS",
          "message": "Already Logged In",
          "data": UserPreferences.loginData,
        });
        Get.offAll(() => HomeView(), binding: HomeBinding());
        // Get.offAll(() => LoginView(), binding: LoginBinding());
      } else {
        Get.offAll(() => HomeView(), binding: HomeBinding());
        // Get.offAll(() => LoginView(), binding: LoginBinding());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x0ffffc60), // Light red
              Color(0xFFFFC371), // Subtle peach
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          // color: Colors.black
        ),
        child: Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (replace with your actual asset)
              Icon(
                Icons.bloodtype, // Can be changed to custom blood drop asset
                size: 100,
                color: Colors.white,
              ),
              // Tagline
              Text(
                "Connecting Lives, One Drop at a Time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

