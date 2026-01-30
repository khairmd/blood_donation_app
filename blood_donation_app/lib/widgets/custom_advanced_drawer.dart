import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:blood_donation_app/screens/home/home_controller.dart';
import 'package:blood_donation_app/screens/login/login_binding.dart';
import 'package:blood_donation_app/screens/login/login_view.dart';
import 'package:blood_donation_app/screens/notification/binding/notification_binding.dart';
import 'package:blood_donation_app/screens/notification/view/notification_screen.dart';
import 'package:blood_donation_app/screens/settings/settings_binding.dart';
import 'package:blood_donation_app/screens/settings/views/settings_screen.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_switch_widget.dart';


class CustomAdvancedDrawer extends StatelessWidget {
  final Widget child;
  final AdvancedDrawerController controller;
  final HomeController homeController;
  const CustomAdvancedDrawer({
    super.key,
    required this.child,
    required this.controller,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      drawer: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomImageView(imagePath: AppConstants.logo, height: 60.h),
              40.verticalSpace,
              _DrawerItem(
                label: "Home",
                pngIcon: AppConstants.homeIcon,
                onTap: () {
                  homeController.currentTabIndex(0);
                  controller.hideDrawer();
                },
              ),
              /*_DrawerItem(
                label: "Today Quiz",
                pngIcon: AppConstants.quizDrawerIcon,
                onTap: () {
                  controller.hideDrawer();
                  Get.to(() => DailyQuizView(), binding: QuizBinding());
                },
              ),
              _DrawerItem(
                label: "Quiz History",
                pngIcon: AppConstants.calendarIcon,
                onTap: () {
                  controller.hideDrawer();
                  Get.to(() => DailyQuizHistoryView(), binding: QuizBinding());
                },
              ),

              _DrawerItem(
                label: "Journal",
                pngIcon: AppConstants.journalDrawerIcon,
                onTap: () {
                  controller.hideDrawer();
                  homeController.currentTabIndex(6);
                },
              ),*/
              _DrawerItem(
                label: "Notification",
                pngIcon: AppConstants.notificationIcon,
                onTap: () {
                  Get.to(() => NotificationScreen(), binding: NotificationBinding());
                },
              ),
              _DrawerItem(
                label: "Subscription",
                pngIcon: AppConstants.subscriptionIcon,
                onTap: () {
                  controller.hideDrawer();
                  homeController.currentTabIndex(8);
                },
              ),
              _DrawerItem(label: "Dark Mode", pngIcon: AppConstants.themeIcon, showSwitch: true),
              // _DrawerItem(
              //   label: "Favorites",
              //   pngIcon: AppConstants.favoriteIcon,
              //   onTap: () {
              //     controller.hideDrawer();
              //     homeController.currentTabIndex(9);
              //   },
              // ),
              _DrawerItem(
                label: "Settings",
                pngIcon: AppConstants.settingIcon,
                onTap: () {
                  controller.hideDrawer();
                  Get.to(() => SettingsScreen(), binding: SettingsBinding());
                },
              ),
              _DrawerItem(
                label: "Sign Out",
                pngIcon: AppConstants.logoutIcon,
                onTap: () {
                  UserPreferences.removeUserData();
                  Get.offAll(() => LoginView(), binding: LoginBinding());
                },
              ),
            ],
          ),
        ),
      ),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.drawerBgColor),
      ),
      controller: controller,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: true,
      childDecoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lightColor.withAlpha(AppGlobals.isDarkMode.value ? 40 : 120),
          width: 10,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
      child: ValueListenableBuilder<AdvancedDrawerValue>(
        valueListenable: controller,
        builder: (_, value, __) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(value.visible ? 32 : 0)),
            ),
            clipBehavior: Clip.hardEdge,

            child: child,
          );
        },
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final String pngIcon;
  final void Function()? onTap;
  final bool showSwitch;
  const _DrawerItem({
    required this.label,
    required this.pngIcon,
    this.onTap,
    this.showSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(imagePath: pngIcon, height: 24.h, color: AppColors.lightColor),
                12.horizontalSpace,
                CustomText(label, fontSize: 16, color: AppColors.lightColor),
                if (showSwitch) ...[
                  Spacer(),
                  Obx(() {
                    return CustomSwitchWidget(
                      value: AppGlobals.isDarkMode.value,
                      onChanged: (value) {
                        AppGlobals.isDarkMode.toggle();
                        Get.changeThemeMode(
                          AppGlobals.isDarkMode.value ? ThemeMode.light : ThemeMode.dark,
                        );
                        Get.forceAppUpdate();
                      },
                    );
                  }),
                ],
              ],
            ),
            3.verticalSpace,
            Divider(
              color:
                  AppGlobals.isDarkMode.value
                      ? AppColors.strokeDarkGreyColor
                      : AppColors.greenStrokeColor,
            ),
          ],
        ),
      ),
    );
  }
}
