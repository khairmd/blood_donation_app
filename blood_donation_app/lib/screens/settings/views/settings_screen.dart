import '../../../widgets/custom_dialog.dart';
import '../settings_controller.dart';
import 'package:flutter/cupertino.dart';
import '../../../widgets/custom_switch_widget.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  SettingsController get controller => Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(text: 'Settings', showBackIcon: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            20.verticalSpace,
            Divider(color: AppColors.dividerColor, thickness: 2.5),
            ListTile(
              leading: SvgPicture.asset(AppConstants.lock),
              contentPadding: EdgeInsets.zero,
              title: CustomText(
                'Change Password',
                style: AppTextTheme.bodyLarge,
              ),
              trailing: Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.primary,
              ),
              onTap: () => Get.to(() => ChangePasswordScreen()),
            ),
            Divider(color: AppColors.dividerColor, thickness: 2.5),
            ListTile(
              leading: SvgPicture.asset(AppConstants.notification),
              contentPadding: EdgeInsets.zero,
              title: CustomText(
                'Notifications Preferences',
                style: AppTextTheme.bodyLarge,
              ),
              trailing: Obx(() {
                return CustomSwitchWidget(
                  value: controller.isNotification.value,
                  onChanged: (value) {
                    controller.isNotification.toggle();
                    // AppGlobals.isDarkMode.toggle();
                    // Get.changeThemeMode(
                    //   AppGlobals.isDarkMode.value ? ThemeMode.light : ThemeMode.dark,
                    // );
                    // Get.forceAppUpdate();
                  },
                );
              }),
            ),
            Divider(color: AppColors.dividerColor, thickness: 2.5),
            ListTile(
              leading: SvgPicture.asset(AppConstants.deleteAccount),
              contentPadding: EdgeInsets.zero,
              title: CustomText(
                'Delete Account',
                style: AppTextTheme.bodyLarge.copyWith(color: AppColors.error),
              ),
              onTap: () {
                Get.dialog(
                  CustomDialog(
                    title: "Delete Account",
                    message:
                        "Are you sure to delete your account? All your data will be deleted",
                    imageIcon: AppConstants.trashIcon,
                    btnText: "Yes, Delete Account",
                    showCloseIcon: true,
                    onButtonTap: () {
                      Get.close(0);
                      Get.dialog(
                        CustomDialogWithTextField(
                          title: "Enter Password To Delete Account",
                          passwordTFController:
                              controller.currentPassTFController,
                          imageIcon: AppConstants.trashIcon,
                          btnText: "Yes, Delete Account",
                          showCloseIcon: true,
                          onButtonTap: () {
                            Get.close(0);
                            controller.deleteAccount(
                              controller.currentPassTFController.text,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
