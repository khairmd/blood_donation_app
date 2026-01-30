import 'package:blood_donation_app/api_core/api_client.dart';
import 'package:blood_donation_app/models/daily_content_model.dart';
import 'package:blood_donation_app/models/hadith_model.dart';
import 'package:blood_donation_app/models/history_model.dart';
import 'package:blood_donation_app/models/quran_ayat_model.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class AyatAndHadithService {
  static Future<DailyContent> getDailyContent() async {
    final res = await ApiClient().get(
      AppUrl.dailyContent,
      queryParameters: {
        "date": DateTime.now().toUtc().toFormatDateTime(format: "yyyy-MM-dd"),
        if (UserPreferences.isLogin) "userId": UserPreferences.userId,
      },
    );
    return DailyContent.fromJson(res.data);
  }

  static Future<QuranAyatModel> getDailyAyat() async {
    final res = await ApiClient().get(AppUrl.ayahApi);
    if (res.data is List) {
      return QuranAyatModel.fromJson(res.data[0]);
    } else {
      return QuranAyatModel.fromJson(res.data);
    }
  }

  static Future<HadithModel> getDailyHadith() async {
    final res = await ApiClient().get(AppUrl.hadithApi);
    if (res.data is List) {
      return HadithModel.fromJson(res.data[0]);
    }
    return HadithModel.fromJson(res.data);
  }

  static Future<HistoryModel> getDailyHistory() async {
    final res = await ApiClient().get(AppUrl.historyApi);
    if (res.data is List) {
      return HistoryModel.fromJson(res.data[0]);
    }
    return HistoryModel.fromJson(res.data);
  }
}
