import 'package:blood_donation_app/screens/subscription/controller/subscription_controller.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_dialog.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  SubscriptionController get controller => Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 60.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        image: DecorationImage(
          image: AssetImage(
          AppConstants.bloodBag
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            CustomImageView(
              imagePath:
                  AppGlobals.isDarkMode.value
                      ? AppConstants.subscriptionDarkImage
                      : AppConstants.subscriptionImage,
              height: 150.h,
            ),
            8.verticalSpace,
            CustomText(
              'Purchase Our Premium \nMembership',
              fontSize: 22.sp,
              maxLine: 2,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              '\$2.99',
              fontSize: 40.sp,
              textAlign: TextAlign.center,

              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            4.verticalSpace,
            CustomText(
              'By purchasing our premium membership you will enjoy an ad free experience and you will also be supporting our app. ',
              fontSize: 14.sp,
              maxLine: 4,
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomRectangleButton(
                    text: "Purchase Now",
                    onTap: () {
                      Get.dialog(
                        CustomDialog(
                          message:
                              "payment has been successfully submitted Thank you for completing the process.",
                          imageIcon: AppConstants.celebrationIcon,
                          title: "Congratulations",
                          btnText: "Close",
                          showCloseIcon: false,
                          onButtonTap: () {
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
