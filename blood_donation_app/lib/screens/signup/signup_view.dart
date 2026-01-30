import 'signup_controller.dart';
import '../login/login_view.dart';
import '../login/login_binding.dart';
import '../../utilities/app_exports.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController.to,
      builder:
          (controller) => Obx(
            () => CustomLoader(
              isTrue: AppGlobals.isLoading.value,
              child: Scaffold(
                extendBody: true,
                backgroundColor: AppColors.scaffoldBackground,
                body: Stack(
                  children: [
                    // 1. Background Image (fixed at the bottom of the stack)
                    Positioned.fill(
                      // Makes the image fill the entire available space
                      child: Obx(
                        () => Image.asset(
                          AppGlobals.isDarkMode.value
                              ? AppConstants.singUpBgDark
                              : AppConstants.singUpBgLight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 2. Content (scrollable on top of the background)
                    SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: signupFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.1),
                            GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  controller.setDummyValuesToControllers();
                                }
                              },
                              child: CustomText(
                                "Create an Account",
                                style: AppTextTheme.headlineSmall,
                              ),
                            ),

                            ///Full Name
                            CustomTextFormField(
                              controller: controller.fullNameTFController,
                              prefixIcon: SvgPicture.asset(
                                AppConstants.profile,
                              ),
                              upperLabel: "Full Name",
                              upperLabelReqStar: "*",
                              hintValue: "Enter Full Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full Name is required';
                                }
                                return null; // Return null if the input is valid
                              },
                              maxLines: 1,
                            ),

                            ///User Name
                            CustomTextFormField(
                              controller: controller.userNameTFController,
                              prefixIcon: SvgPicture.asset(
                                AppConstants.profile,
                              ),
                              upperLabel: "User Name",
                              upperLabelReqStar: "*",
                              hintValue: "Enter User Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'User Name is required';
                                }
                                return null; // Return null if the input is valid
                              },
                              maxLines: 1,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null; // Return null if the input is valid
                              },
                              maxLines: 1,
                            ),

                            ///Confirm Password
                            CustomTextFormField(
                              controller:
                                  controller.confirmPasswordTFController,
                              upperLabel: "Confirm Password",
                              upperLabelReqStar: "*",
                              hintValue: "Enter Confirm Password",
                              prefixIcon: SvgPicture.asset(AppConstants.lock),
                              enableInteractiveSelection: true,
                              enableSuggestions: false,
                              obscureText: true,
                              validator:
                                  (confirmPwd) => validateConfirmPassword(
                                    controller.passwordTFController.text,
                                    confirmPwd,
                                  ),
                              maxLines: 1,
                            ),

                            SizedBox(height: Get.height * 0.025),

                            ///Sign Up Button
                            CustomRectangleButton(
                              width: Get.width,
                              text: "Create Account",
                              onTap: () {
                                if (!signupFormKey.currentState!.validate()) {
                                  return;
                                }
                                controller.singUp();
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
        SizedBox(height: Get.height * 0.02),
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
        SizedBox(height: Get.height * 0.02),

        // Google and Apple Sign-in Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: SvgPicture.asset(AppConstants.google),
              // Replace with your Google logo asset
              onPressed: () {
                // Handle Google sign-in
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
              "Already Have An Account? ",
              style: AppTextTheme.bodyLarge,
            ),
            GestureDetector(
              onTap: () {
                Get.off(() => LoginView(),binding: LoginBinding());
              },
              child: CustomText(
                "Sign In",
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
