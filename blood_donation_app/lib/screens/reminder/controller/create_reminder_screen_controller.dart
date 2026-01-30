import 'package:hijri/hijri_calendar.dart';
import 'package:blood_donation_app/api_core/custom_exception_handler.dart';
import 'package:blood_donation_app/api_services/reminder_service.dart';
import 'package:blood_donation_app/models/reminder_detail_model.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_dialog.dart';

enum ReminderType {
  once("Only Once"),
  repeat("Every Time");

  final String name;
  const ReminderType(this.name);

  @override
  String toString() => name;
}

class CreateReminderScreenController extends GetxController {
  final TextEditingController reminderTitleController = TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();
  final TextEditingController selectedTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  HijriCalendar? selectedHijriDate;
  TimeOfDay? selectedTime;

  RxBool isRepeat = false.obs;

  RxInt currentTabIndex = 0.obs;

  ReminderType selectedReminderType = ReminderType.once;

  onReminderTypeSelect(ReminderType? reminderType) {
    selectedReminderType = reminderType ?? ReminderType.once;
    update(['type']);
  }

  setDetails(ReminderDetails? reminderDetail) {
    if (reminderDetail?.date != null) {
      selectedDate = reminderDetail?.date ?? DateTime.now();
      selectedHijriDate = HijriCalendar.fromDate(selectedDate ?? DateTime.now());
      selectedDateController.text =
          "${reminderDetail?.date.toFormatDateTime(format: "dd MMM, yyyy")}/ ${selectedHijriDate?.hDay ?? ""} ${selectedHijriDate?.longMonthName ?? ""} ${selectedHijriDate?.hYear ?? ""}";
    }
    reminderTitleController.text = reminderDetail?.title ?? "";
    selectedTimeController.text = reminderDetail?.time ?? "";
    descriptionController.text = reminderDetail?.description ?? "";
    selectedReminderType = reminderDetail?.type == "once" ? ReminderType.once : ReminderType.repeat;
    currentTabIndex.value = setReminderType(reminderDetail?.type);
  }

  createReminder({bool isEditing = false, ReminderDetails? reminderDetail}) async {
    try {
      AppGlobals.isLoading(true);
      //Will work on UTC later
      // if (selectedDate != null) {
      //   selectedDate =
      //       DateTime(
      //         selectedDate!.year,
      //         selectedDate!.month,
      //         selectedDate!.day,
      //         selectedTime!.hour,
      //         selectedTime!.minute,
      //       ).toUtc();
      // }
      Map<String, dynamic> data = {
        "title": reminderTitleController.text,
        if (selectedReminderType == ReminderType.once || [2, 3].contains(currentTabIndex.value))
          "date": selectedDate.toFormatDateTime(format: "yyyy-MM-dd"),
        "time":
            selectedTime != null
                ? "${selectedTime?.hour}:${selectedTime?.minute}"
                : selectedTimeController.text,
        "description": descriptionController.text,
        "type":
            selectedReminderType == ReminderType.once
                ? "once"
                : getReminderType(currentTabIndex.value),
        if (isEditing) "id": reminderDetail?.id,
      };

      final res =
          isEditing
              ? await ReminderService.editReminder(data, reminderDetail?.id ?? "")
              : await ReminderService.createReminder(data);
      if (res != null) {
        Get.dialog(
          barrierDismissible: false,
          CustomDialog(
            message:
                isEditing
                    ? "Your reminder has been successfully updated. Changes will take effect immediately."
                    : "Your reminder has been saved successfully. We’ll notify you at the scheduled time.",
            imageIcon: AppConstants.celebrationIcon,
            title: isEditing ? "Reminder Updated" : "Reminder Saved",
            btnText: "Close",
            showCloseIcon: false,
            onButtonTap: () {
              Get.back();
              Get.back(result: true);
            },
          ),
        );
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  String? getReminderType(int index) {
    switch (index) {
      case 0:
        return "daily";
      case 1:
        return "weekly";
      case 2:
        return "monthly";
      case 3:
        return "yearly";
      default:
        return null;
    }
  }

  int setReminderType(String? type) {
    switch (type) {
      case "daily":
        return 0;
      case "weekly":
        return 1;
      case "monthly":
        return 2;
      case "yearly":
        return 3;
      default:
        return 0;
    }
  }
}
