import '../../../utilities/app_exports.dart';
import '../forgot_password_controller.dart';

class PasswordRecoveryView extends StatelessWidget {
  final GlobalKey<FormState> passwordRecoveryFormKey = GlobalKey<FormState>();

  PasswordRecoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: Get.put(ForgotPasswordController()),
      builder:
          (controller) => Obx(
            () => CustomLoader(
              isTrue: AppGlobals.isLoading.value,
              child: Scaffold(
                extendBody: true,
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.journalBackgroundColor,
                body: Stack(
                  children: [
                    Stack(
                      children: [
                        // 1. Background Image (fixed at the bottom of the stack)
                        Positioned.fill(
                          // Makes the image fill the entire available space
                          child: Obx(
                            () => Image.asset(
                              AppGlobals.isDarkMode.value
                                  ? AppConstants.forgetPassBgDark
                                  : AppConstants.forgetPassBgLight,
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // 2. Content (scrollable on top of the background)
                        SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: passwordRecoveryFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Get.height * 0.3),
                                InkWell(
                                  onTap: () {
                                    if (kDebugMode) {
                                      controller.emailTFController.text =
                                          'ahsan@yopmail.com';
                                    }
                                  },
                                  child: CustomText(
                                    'Forget Password',
                                    style: AppTextTheme.headlineSmall,
                                  ),
                                ),
                                CustomText(
                                  'Enter your registered email address to receive instructions on resetting your password',
                                  style: AppTextTheme.bodyLarge,
                                  maxLine: 3,
                                ),
                                SizedBox(height: Get.height * 0.02),

                                ///Email
                                CustomTextFormField(
                                  controller: controller.emailTFController,
                                  upperLabel: "Email Address",
                                  upperLabelReqStar: "*",
                                  prefixIcon: SvgPicture.asset(
                                    AppConstants.mail,
                                  ),
                                  hintValue: "Enter Email Address",
                                  validator: (value) => validateEmail(value),
                                  type: TextInputType.emailAddress,
                                  inputFormatters: [
                                    FilteringTextInputFormatter(
                                      RegExp(r'[a-zA-Z0-9@._-]'),
                                      allow: true,
                                    ),
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.02),

                                ///Send OTP In Button
                                CustomRectangleButton(
                                  width: context.width,
                                  text: "Send OTP",
                                  onTap: () {
                                    if (!passwordRecoveryFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    controller.sendOTP();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: Get.height * 0.05,
                      left: 10,
                      child: CustomBackButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
