import 'package:blood_donation_app/api_core/api_client.dart';
import 'package:blood_donation_app/models/journal_model.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class JournalServices {
  static Future<JournalDetail?> createJournal(Map<String, dynamic> data) async {
    final res = await ApiClient().post(AppUrl.journalApi, data: data);
    return JournalDetail.fromJson(res.data);
  }

  static Future<JournalDetail?> editJournal(Map<String, dynamic> data, String id) async {
    final res = await ApiClient().put("${AppUrl.journalApi}/$id", data: data);
    return JournalDetail.fromJson(res.data);
  }

  static Future<JournalDetail?> deleteJournal(String id) async {
    final res = await ApiClient().delete("${AppUrl.journalApi}/$id");
    return JournalDetail.fromJson(res.data);
  }

  static Future<JournalsModel?> getAllJournal(Map<String, dynamic> queryParameters) async {
    final res = await ApiClient().get(AppUrl.journalApi, queryParameters: queryParameters);
    return JournalsModel.fromJson(res.data);
  }
}
