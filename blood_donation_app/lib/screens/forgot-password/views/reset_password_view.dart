
import '../../../utilities/app_exports.dart';
import '../forgot_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: Get.put(ForgotPasswordController()),
      builder: (controller) => Obx(()=>CustomLoader(
        isTrue: AppGlobals.isLoading.value,
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.journalBackgroundColor,
          body: Container(
            height: Get.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppGlobals.isDarkMode.value
                      ? AppConstants.resetPassBgDark
                      : AppConstants.resetPassBgLight,
                ),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: resetPasswordFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.38),
                    InkWell(
                      onTap: () {
                        if (kDebugMode) {
                          controller.passwordTFController.text = '1234';
                          controller.confirmPasswordTFController.text = '1234';
                        }
                      },
                      child: CustomText(
                        'Reset Your Password',
                        style: AppTextTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Forgot your Password? No worries!",
                          style: AppTextTheme.bodyLarge,
                        ),
                        CustomText(
                          "Reset It Now And Regain Access Instantly",
                          style: AppTextTheme.bodyLarge,
                        ),
                      ],
                    ),

                    SizedBox(height: Get.height * 0.02),

                    ///New Pin
                    CustomTextFormField(
                      outerPadding: EdgeInsets.zero,
                      controller: controller.passwordTFController,
                      upperLabel: "Password".tr,
                      upperLabelReqStar: "*",
                      hintValue: ('•' * 4).tr,
                      obscureText: true,
                      prefixIcon: SvgPicture.asset(AppConstants.lock),
                      validator: (value) => validatePassword(value),
                      inputFormatters: [
                        BlankSpaceInputFormatter(),
                      ],
                    ),

                    ///Confirm Password
                    CustomTextFormField(
                      // outerPadding: EdgeInsets.zero,
                      controller: controller.confirmPasswordTFController,
                      upperLabel: "Confirm Password".tr,
                      upperLabelReqStar: "*",
                      hintValue: ('•' * 4).tr,
                      obscureText: true,
                      prefixIcon: SvgPicture.asset(AppConstants.lock),
                      validator: (value) => validateConfirmPassword(
                          value, controller.passwordTFController.text),
                      inputFormatters: [
                        BlankSpaceInputFormatter(),
                      ],
                    ),

                    SizedBox(height: Get.height * 0.02),

                    ///Update Password Button
                    CustomRectangleButton(
                        width: context.width,
                        text: "Update Password",
                        onTap: () {
                          if (!resetPasswordFormKey.currentState!.validate()) {
                            return;
                          }
                          controller.resetPassword();

                        }),
                    SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
