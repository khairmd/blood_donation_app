import 'package:hijri/hijri_calendar.dart';
import 'package:blood_donation_app/models/reminder_detail_model.dart';
import 'package:blood_donation_app/screens/reminder/controller/create_reminder_screen_controller.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/utilities/app_helper.dart';
import 'package:blood_donation_app/utilities/validators.dart';
import 'package:blood_donation_app/widgets/custom_calendar.dart';
import 'package:blood_donation_app/widgets/custom_radio_button.dart';
import 'package:blood_donation_app/widgets/custom_tab_widget.dart';

class CreateReminderScreen extends StatelessWidget {
  final ReminderDetails? reminderDetails;
  const CreateReminderScreen({super.key, this.reminderDetails});

  CreateReminderScreenController get controller => Get.put(CreateReminderScreenController());
  @override
  Widget build(BuildContext context) {
    if (reminderDetails != null) {
      controller.setDetails(reminderDetails!);
    }
    return Scaffold(
      appBar: CustomAppBar(
        text: reminderDetails != null ? "Edit Reminder" : "Create Reminder",
        centerTitle: true,
        showBackIcon: true,
        bgColor: AppColors.appBarBgColor,
      ),
      backgroundColor: AppColors.journalBackgroundColor,
      body: Stack(
        children: [
          CustomImageView(
            imagePath:
                AppGlobals.isDarkMode.value
                    ? AppConstants.createJournalBgDarkImage
                    : AppConstants.createJournalBgImage,
            height: 150.h,
            fit: BoxFit.contain,
          ),
          Obx(() {
            return CustomLoader(
              isTrue: AppGlobals.isLoading.value,
              child: Form(
                key: controller.formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    50.verticalSpace,
                    CustomImageView(
                      imagePath: AppConstants.reminderCalendarIcon,
                      height: 80.h,
                      fit: BoxFit.contain,
                    ),
                    20.verticalSpace,
                    GetBuilder(
                      init: controller,
                      id: "type",
                      builder: (_) {
                        return Visibility(
                          visible: controller.selectedReminderType == ReminderType.repeat,
                          child: Obx(() {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              height: 36.h,
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldBackground,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: AppColors.primary, width: 1),
                              ),
                              child: DefaultTabController(
                                length: 4,
                                initialIndex: controller.currentTabIndex.value,
                                child: TabBar(
                                  dividerColor: Colors.transparent,
                                  labelPadding: EdgeInsets.zero,
                                  tabs: [
                                    CustomTab(
                                      title: "Daily",
                                      isSelected: controller.currentTabIndex.value == 0,
                                    ),
                                    CustomTab(
                                      title: "Weekly",
                                      isSelected: controller.currentTabIndex.value == 1,
                                    ),
                                    CustomTab(
                                      title: "Monthly",
                                      isSelected: controller.currentTabIndex.value == 2,
                                    ),
                                    CustomTab(
                                      title: "Yearly",
                                      isSelected: controller.currentTabIndex.value == 3,
                                    ),
                                  ],
                                  isScrollable: false,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  onTap: (value) {
                                    controller.currentTabIndex.value = value;
                                    controller.update();
                                  },
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    20.verticalSpace,
                    CustomTextFormField(
                      upperLabel: "Title",
                      controller: controller.reminderTitleController,
                      hintValue: "Enter Title",
                      upperLabelReqStar: "",
                      outerPadding: EdgeInsets.zero,
                      maxLines: 1,
                      suffixIcon: CustomImageView(
                        svgPath: AppConstants.personalCardSvgIcon,
                        height: 20.h,
                      ),
                      validator: Validators.required,
                    ),
                    8.verticalSpace,
                    GetBuilder(
                      init: controller,
                      id: "type",
                      builder: (_) {
                        return Obx(() {
                          return Visibility(
                            visible:
                                [2, 3].contains(controller.currentTabIndex.value) ||
                                controller.selectedReminderType == ReminderType.once,
                            child: GestureDetector(
                              onTap: () {
                                showDualCalendar(
                                  context,
                                  initialDate: controller.selectedDate,
                                  selectedDate: controller.selectedDate,
                                  onDateSelected: (date) {
                                    controller.selectedDate = date;
                                    controller.selectedHijriDate = HijriCalendar.fromDate(date);
                                    controller.selectedDateController.text =
                                        "${date.toFormatDateTime(format: "dd MMM, yyyy")}/ ${controller.selectedHijriDate?.hDay ?? ""} ${controller.selectedHijriDate?.longMonthName ?? ""} ${controller.selectedHijriDate?.hYear ?? ""}";
                                  },
                                );
                              },
                              child: CustomTextFormField(
                                upperLabel: "Select Date",
                                enabled: false,
                                controller: controller.selectedDateController,
                                hintValue: "Select Date",
                                upperLabelReqStar: "",
                                outerPadding: EdgeInsets.zero,
                                suffixIcon: CustomImageView(
                                  svgPath: AppConstants.calendarSvgIcon,
                                  height: 20.h,
                                ),
                                validator: Validators.required,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    8.verticalSpace,

                    GestureDetector(
                      onTap: () {
                        Helper.pickTime(context, controller.selectedTime).then((value) {
                          controller.selectedTime = value;
                          controller.selectedTimeController.text = value?.format(context) ?? "";
                        });
                      },
                      child: CustomTextFormField(
                        upperLabel: "Select Time",
                        controller: controller.selectedTimeController,
                        enabled: false,
                        hintValue: "Select Time",
                        upperLabelReqStar: "",
                        outerPadding: EdgeInsets.zero,
                        suffixIcon: CustomImageView(
                          svgPath: AppConstants.clockSvgIcon,
                          height: 20.h,
                        ),
                        validator: Validators.required,
                      ),
                    ),
                    8.verticalSpace,

                    CustomTextFormField(
                      upperLabel: "Description",
                      controller: controller.descriptionController,
                      hintValue: "Enter reminder description",
                      upperLabelReqStar: "",
                      outerPadding: EdgeInsets.zero,
                      maxLines: 4,
                      type: TextInputType.multiline,
                      validator: Validators.required,
                    ),
                    8.verticalSpace,

                    ///1
                    GetBuilder(
                      init: controller,
                      id: "type",
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Column(
                            children: [
                              12.verticalSpace,
                              ReminderTypeRadioWidget(
                                type: ReminderType.once,
                                groupValue: controller.selectedReminderType,
                                onChanged: controller.onReminderTypeSelect,
                              ),
                              const SizedBox(width: 24, height: 12),
                              ReminderTypeRadioWidget(
                                type: ReminderType.repeat,
                                groupValue: controller.selectedReminderType,
                                onChanged: controller.onReminderTypeSelect,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    ///2
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Obx(() {
                    //       return CustomCheckBox(
                    //         label: "Repeat",
                    //         value: controller.isRepeat.value,
                    //         shadowColor:
                    //             AppGlobals.isDarkMode.value ? Colors.transparent : Colors.grey.shade300,
                    //         fillColor: AppColors.dialogBgColor,
                    //         activeColor: AppColors.primary,
                    //         padding: EdgeInsets.only(left: 4),
                    //         onChanged: (value) {
                    //           controller.isRepeat.value = value;
                    //         },
                    //       );
                    //     }),
                    //   ],
                    // ),
                    8.verticalSpace,
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: CustomRectangleButton(
            text: reminderDetails != null ? "Update" : "Create Reminder",
            onTap: () {
              if (!controller.formKey.currentState!.validate()) {
                return;
              }
              controller.createReminder(
                isEditing: reminderDetails != null,
                reminderDetail: reminderDetails,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ReminderTypeRadioWidget extends StatelessWidget {
  final ReminderType type;
  final ReminderType groupValue;
  final void Function(ReminderType?) onChanged;
  final bool isDisabled;
  const ReminderTypeRadioWidget({
    super.key,
    required this.type,
    required this.onChanged,
    required this.groupValue,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged(type),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(30),
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(type.name, fontSize: 14.sp),
            CustomRadio<ReminderType>(
              value: type,
              groupValue: groupValue,

              activeColor: isDisabled ? AppColors.greyTextColor : AppColors.primary,
              outLineColor: isDisabled ? AppColors.greyTextColor : AppColors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
    // return Row(
    //   children: [
    //     CustomRadio<ReminderType>(
    //       value: type,
    //       groupValue: groupValue,
    //       activeColor: isDisabled ? AppColors.greyTextColor : AppColors.primary,
    //       outLineColor: isDisabled ? AppColors.greyTextColor : AppColors.primary,
    //       onChanged: onChanged,
    //     ),
    //     CustomText(type.name, fontWeight: FontWeight.w500, fontSize: 16.sp),
    //   ],
    // );
  }
}
