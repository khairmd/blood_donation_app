import 'package:blood_donation_app/api_core/api_client.dart';
import 'package:blood_donation_app/models/reminder_detail_model.dart';
import 'package:blood_donation_app/models/reminders_model.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class ReminderService {
  static Future<ReminderDetails?> createReminder(Map<String, dynamic> data) async {
    final res = await ApiClient().post(AppUrl.reminderApi, data: data);
    return ReminderDetails.fromJson(res.data);
  }

  static Future<ReminderDetails?> editReminder(Map<String, dynamic> data, String id) async {
    final res = await ApiClient().put("${AppUrl.reminderApi}/$id", data: data);
    return ReminderDetails.fromJson(res.data);
  }

  static Future<ReminderDetails?> deleteReminder(String id) async {
    final res = await ApiClient().delete("${AppUrl.reminderApi}/$id");
    return ReminderDetails.fromJson(res.data);
  }

  static Future<RemindersModel?> getAllReminder(Map<String, dynamic> queryParameters) async {
    final res = await ApiClient().get(
      "${AppUrl.reminderApi}/users/${UserPreferences.userId}",
      queryParameters: queryParameters,
    );
    return RemindersModel.fromJson(res.data);
  }
}
