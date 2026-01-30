import 'package:blood_donation_app/screens/reminder/bindings/create_reminder_screen_binding.dart';
import 'package:blood_donation_app/screens/reminder/controller/reminder_screen_controller.dart';
import 'package:blood_donation_app/screens/reminder/views/create_reminder_screen.dart';
import 'package:blood_donation_app/screens/reminder/views/reminder_listing_screen.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  ReminderScreenController get controller => Get.put(ReminderScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (_) {
        return Obx(() {
          return CustomLoader(
            isTrue: AppGlobals.isLoading.value,
            child: Visibility(
              visible: controller.isReminderCreated.value,

              replacement:
                  AppGlobals.isLoading.value
                      ? SizedBox()
                      : Container(
                        height: double.infinity,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 60.h),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          image: DecorationImage(
                            image: AssetImage(
                              AppGlobals.isDarkMode.value
                                  ? AppConstants.reminderBgDarkImage
                                  : AppConstants.reminderBgImage,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                              CustomImageView(
                                imagePath: AppConstants.reminderCalendarIcon,
                                height: 100.h,
                              ),
                              24.verticalSpace,
                              CustomText(
                                'No Reminder Yet',
                                fontSize: 20.sp,
                                textAlign: TextAlign.center,
                              ),
                              24.verticalSpace,
                              CustomText(
                                'Big things start with small steps. Add a reminder to keep your goals in sight and your schedule in check.',
                                fontSize: 16.sp,
                                maxLine: 3,
                                textAlign: TextAlign.center,
                              ),
                              24.verticalSpace,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomRectangleButton(
                                      text: "Add Reminder",
                                      iconWidget: Icon(
                                        Icons.add,
                                        color: AppColors.lightColor,
                                        size: 18.h,
                                      ),
                                      iconAlignment: IconAlignment.end,
                                      onTap: () {
                                        Get.to(
                                          () => CreateReminderScreen(),
                                          binding: CreateReminderScreenBinding(),
                                        )?.then((value) {
                                          if (value == true) {
                                            controller.isReminderCreated.value = true;
                                            controller.onRefresh();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

              child: ReminderListingScreen(),
            ),
          );
        });
      },
    );
  }
}
