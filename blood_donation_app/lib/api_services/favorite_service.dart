import 'package:blood_donation_app/api_core/api_client.dart';
import 'package:blood_donation_app/models/favorite_ayat_model.dart';
import 'package:blood_donation_app/models/favorite_hadith_model.dart';
import 'package:blood_donation_app/models/favorite_history_model.dart';
import 'package:blood_donation_app/utilities/app_url.dart';

class FavoriteService {
  static Future<dynamic> addAyatToFavorite(String id) async {
    final res = await ApiClient().post("${AppUrl.ayahApi}/$id/favorite");
    return res.data;
  }

  static Future<dynamic> removeAyatFromFavorite(String id) async {
    final res = await ApiClient().delete("${AppUrl.ayahApi}/$id/favorite");
    return res.data;
  }

  static Future<dynamic> addHadithToFavorite(String id) async {
    final res = await ApiClient().post("${AppUrl.hadithApi}/$id/favorite");
    return res.data;
  }

  static Future<dynamic> removeHadithFromFavorite(String id) async {
    final res = await ApiClient().delete("${AppUrl.hadithApi}/$id/favorite");
    return res.data;
  }

  static Future<dynamic> addHistoryToFavorite(String id) async {
    final res = await ApiClient().post("${AppUrl.historyApi}/$id/favorite");
    return res.data;
  }

  static Future<dynamic> removeHistoryFromFavorite(String id) async {
    final res = await ApiClient().delete("${AppUrl.historyApi}/$id/favorite");
    return res.data;
  }

  static Future<List<FavoriteAyahModel>> getFavoriteAyat() async {
    final res = await ApiClient().get(AppUrl.ayahFavoriteApi);
    if (res.data is List) {
      return List<FavoriteAyahModel>.from(res.data.map((x) => FavoriteAyahModel.fromJson(x)));
    }

    return [];
  }

  static Future<List<FavoriteHadithModel>> getFavoriteHadith() async {
    final res = await ApiClient().get(AppUrl.hadithFavoriteApi);
    if (res.data is List) {
      return List<FavoriteHadithModel>.from(res.data.map((x) => FavoriteHadithModel.fromJson(x)));
    }
    return [];
  }

  static Future<List<FavoriteHistoryModel>> getFavoriteHistory() async {
    final res = await ApiClient().get(AppUrl.historyFavoriteApi);
    if (res.data is List) {
      return List<FavoriteHistoryModel>.from(res.data.map((x) => FavoriteHistoryModel.fromJson(x)));
    }
    return [];
  }
}
