import '../../../utilities/app_exports.dart';
import '../../login/login_view.dart';

class ResetPasswordSuccessView extends StatelessWidget {
  const ResetPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.journalBackgroundColor,
      body: Container(
        height: Get.height,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppGlobals.isDarkMode.value
                  ? AppConstants.passResetSuccessBgDark
                  : AppConstants.passResetSuccessBgLight,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.06),
            CustomText('Password Reset', style: AppTextTheme.headlineSmall),
            SizedBox(height: Get.height * 0.01),
            CustomText(
              "Your password has been reset. You can now sign in to your account.",
              style: AppTextTheme.bodyLarge,
              maxLine: 2,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: Get.height * 0.02),

            ///Update Password Button
            CustomRectangleButton(
              width: context.width,
              text: "Back to Login",
              onTap: () {
                Get.offAll(() => LoginView());
              },
            ),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
      ),
    );
  }
}
