import 'package:blood_donation_app/screens/dashboard/dashboard_controller.dart';
import 'package:blood_donation_app/screens/find-doctors/find_doctors.dart';
import 'package:blood_donation_app/screens/home/home_controller.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/screens/donor-finder/donor_finder_screen.dart';
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  DashboardController get controller => Get.put(DashboardController());
  HomeController get homeController => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Obx(() {
      return CustomLoader(
        isTrue: AppGlobals.isLoading.value,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AppConstants.home))
          ),
          padding: EdgeInsets.only(top: kMinInteractiveDimension),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRectangleButton(
                    text: 'Find Doctors',
                    onTap: (){
                      Get.to(()=>FindDoctorsView());
                    },
                  width: double.infinity,
                ),
                10.verticalSpace,
                CustomRectangleButton(text: 'Request Blood', onTap: (){
                  Get.to(()=>DonorFinderScreen());
                },width: double.infinity,),
                // 30.verticalSpace,

              ],
            ),
          ),
        ),
      );
    });
  }

  onInfoTap(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog();
      },
    );
  }
}

class _HomeTileWidget extends StatelessWidget {
  final String label;
  final String svgIcon;
  const _HomeTileWidget({required this.label, required this.svgIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.homeScreenCardBgColor,
        border: Border.all(color: AppColors.strokeColor),
        image: DecorationImage(
          image: AssetImage(
            AppGlobals.isDarkMode.value
                ? AppConstants.homeTileBgDarkImage
                : AppConstants.homeTileBgImage,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          10.verticalSpace,

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(label, color: AppColors.lightColor),
          ),
          20.verticalSpace,
          CustomImageView(svgPath: svgIcon, height: 56.h),
          10.verticalSpace,
        ],
      ),
    );
  }
}
