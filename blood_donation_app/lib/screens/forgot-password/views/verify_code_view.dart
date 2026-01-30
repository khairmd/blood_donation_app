import '../forgot_password_controller.dart';
import '../../../utilities/app_exports.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeView extends StatelessWidget {
  final GlobalKey<FormState> verifyCodeFormKey = GlobalKey<FormState>();
  final String email;

  VerifyCodeView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: Get.put(ForgotPasswordController()),
      initState: (state) {
        ForgotPasswordController.to.otpTFController.clear();
        ForgotPasswordController.to.startTimer();
      },
      builder:
          (controller) => Obx(
            () => CustomLoader(
              isTrue: AppGlobals.isLoading.value,
              child: Scaffold(
                extendBody: true,
                backgroundColor: AppColors.journalBackgroundColor,
                resizeToAvoidBottomInset: false,
                body: Container(
                  height: Get.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AppGlobals.isDarkMode.value
                            ? AppConstants.otpCodeBgDark
                            : AppConstants.otpCodeBgLight,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: verifyCodeFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.42),
                          InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                controller.otpTFController.text = '1234';
                              }
                            },
                            child: CustomText(
                              'OTP Code',
                              style: AppTextTheme.headlineSmall,
                            ),
                          ),
                          CustomText(
                            'Your Key to Safe and Instant Verification',
                            style: AppTextTheme.bodyLarge,
                          ),
                          SizedBox(height: Get.height * 0.02),

                          ///Otp widget
                          otpWidget(context, controller),

                          ///Verify OTP Button
                          CustomRectangleButton(
                            width: context.width,
                            text: "Submit Code",

                            onTap: () {
                              if (!verifyCodeFormKey.currentState!.validate()) {
                                return;
                              }
                              controller.verifyOtp();
                            },
                          ),
                          Obx(
                            () => Align(
                              alignment: Alignment.centerLeft,
                              child: timerWidget(context, controller),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          // const CustomBackButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget otpWidget(BuildContext context, ForgotPasswordController controller) {
    return PinCodeTextField(
      autoFocus: true,
      appContext: context,
      inputFormatters: [
        BlankSpaceInputFormatter(),
        FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true),
      ],
      length: 4,
      obscureText: false,
      obscuringCharacter: '*',
      // hintCharacter: "|",
      animationType: AnimationType.fade,
      autovalidateMode: AutovalidateMode.disabled,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 48,
        fieldWidth: 73,
        inactiveColor: AppColors.textFieldBorderColor,
        selectedColor: AppColors.textFieldBorderColor,
        activeFillColor: AppColors.textFieldBorderColor,
        activeColor: AppColors.textFieldBorderColor,
        // fieldOuterPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4)
      ),
      cursorColor: AppColors.primary,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: AppTextTheme.bodyLarge.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      enableActiveFill: false,
      showCursor: true,
      controller: controller.otpTFController,
      autoDisposeControllers: false,
      keyboardType: TextInputType.number,
      onCompleted: (v) {
        if (controller.otpTFController.text.length == 4) {
          debugPrint("Success");
        } else {
          debugPrint("Failure");
        }
      },
      errorTextSpace: 25,
      validator: (v) {
        if (v.isNullOREmpty) {
          return "Enter OTP".tr;
        } else if (v!.length < 4) {
          return "Enter 4 digits OTP sent to ${controller.emailTFController.text}"
              .tr;
        } else {
          return null;
        }
      },
      onChanged: (value) {
        debugPrint(value);
        controller.otp.value = value;
      },
      beforeTextPaste: (text) {
        debugPrint("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return false;
      },
    );
  }

  Widget timerWidget(
    BuildContext context,
    ForgotPasswordController controller,
  ) {
    if (controller.timerSeconds.value > 0) {
      // Calculate minutes and seconds
      int minutes = controller.timerSeconds.value ~/ 60; // Integer division
      int seconds = controller.timerSeconds.value % 60;  // Modulo for remaining seconds

      // Format seconds with leading zero if less than 10
      String formattedSeconds = seconds.toString().padLeft(2, '0');
      String formattedMinutes = minutes.toString().padLeft(2, '0');


      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: CustomText(
          "Wait for $formattedMinutes:$formattedSeconds min", // Display MM:SS
          style: AppTextTheme.bodyLarge,
        ),
      );
    } else {
      return Obx(() {
        return controller.timerSeconds.value == 0
            ? Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  controller.resendOtp({"email": email});
                },
                child: CustomText(
                  'Send Again',
                  style: AppTextTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            )
            : const SizedBox.shrink();
      });
    }
  }
}
