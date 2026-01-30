import '../home/home_binding.dart';
import '../home/home_view.dart';
import 'login_controller.dart';
import '../signup/signup_view.dart';
import '../signup/signup_binding.dart';
import '../../utilities/app_exports.dart';
import '../forgot-password/forgot_password_binding.dart';
import '../forgot-password/views/password_recovery_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  LoginController get controller => Get.put(LoginController());
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: controller,
      builder:
          (_) => Obx(
            () => CustomLoader(
              isTrue: AppGlobals.isLoading.value,
              child: Scaffold(
                extendBody: true,
                backgroundColor: AppColors.scaffoldBackground,
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    // 1. Background Image (fixed at the bottom of the stack)
                    Positioned.fill(
                      // Makes the image fill the entire available space
                      child: Obx(
                            () => Image.asset(
                              AppGlobals.isDarkMode.value
                                  ? AppConstants.singInBgDark
                                  : AppConstants.singInBgLight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 2. Content (scrollable on top of the background)
                    SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.3),
                            GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  controller.emailTFController.text =
                                  "hananqureshi386@gmail.com";
                                  controller.passwordTFController.text = "1234";
                                }
                              },
                              child: CustomText(
                                "Welcome to Path To Water",
                                style: AppTextTheme.headlineSmall,
                              ),
                            ),

                            ///Email
                            CustomTextFormField(
                              controller: controller.emailTFController,
                              prefixIcon: SvgPicture.asset(AppConstants.mail),
                              upperLabel: "Email Address",
                              upperLabelReqStar: "*",
                              hintValue: "Enter Email Address",
                              validator: (value) => validateEmail(value),
                              type: TextInputType.emailAddress,
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9@._-]'),
                                  allow: true,
                                ),
                              ],
                              maxLines: 1,
                            ),

                            ///Password
                            CustomTextFormField(
                              controller: controller.passwordTFController,
                              upperLabel: "Password",
                              upperLabelReqStar: "*",
                              hintValue: "Enter Password",
                              prefixIcon: SvgPicture.asset(AppConstants.lock),
                              enableInteractiveSelection: true,
                              enableSuggestions: false,
                              obscureText: true,
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null; // Return null if the input is valid
                              },
                            ),
                            SizedBox(height: Get.height * 0.01),

                            ///Forgot Password TextButton
                            Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  UserPreferences.isLogin = true;
                                  Get.to(
                                        () => PasswordRecoveryView(),
                                    binding: ForgotPasswordBinding(),
                                  );
                                },
                                child: CustomText(
                                  'Forgot Password?',
                                  style: AppTextTheme.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),

                            ///Sign In Button
                            CustomRectangleButton(
                              width: Get.width,
                              text: "Login",
                              onTap: () {
                                if (!loginFormKey.currentState!.validate()) {
                                  return;
                                }
                                UserPreferences.isLogin = true;
                                Get.off(() => HomeView(), binding: HomeBinding());
                              },
                            ),
                            _socialSignInSection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _socialSignInSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: Get.height * 0.025),
        // "Or Continue With" text with lines
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SvgPicture.asset(AppConstants.rightLine)),
              CustomText('Or Continue With', style: AppTextTheme.bodyLarge),
              Expanded(child: SvgPicture.asset(AppConstants.leftLine)),
            ],
          ),
        ),
        SizedBox(height: Get.height * 0.015),

        // Google and Apple Sign-in Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: SvgPicture.asset(AppConstants.google),
              // Replace with your Google logo asset
              onPressed: () {
                // Handle Google sign-in
                controller.signInWithGoogle();
              },
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              icon: SvgPicture.asset(
                AppConstants.apple,
                colorFilter: ColorFilter.mode(
                  AppGlobals.isDarkMode.value ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                // Handle Apple sign-in
              },
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.02),

        // "Don't have an account? Sign Up" text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              "Don't have an account? ",
              style: AppTextTheme.bodyLarge,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SignupView(), binding: SignupBinding());
              },
              child: CustomText(
                "Sign Up",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  // Or your app's primary color
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textSecondary,
                  fontFamily: AppFonts.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 80, // Adjust size as needed
      height: 60, // Adjust size as needed
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor, // Dark background color from image
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textFieldBorderColor,
        ), // Subtle border
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
