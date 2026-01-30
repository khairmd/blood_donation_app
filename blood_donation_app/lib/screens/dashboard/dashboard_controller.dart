import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/api_core/custom_exception_handler.dart';
import 'package:blood_donation_app/api_services/ayat_and_hadith_service.dart';
import 'package:blood_donation_app/api_services/favorite_service.dart';
import 'package:blood_donation_app/models/hadith_model.dart';
import 'package:blood_donation_app/models/history_model.dart';
import 'package:blood_donation_app/models/quran_ayat_model.dart';
import 'package:blood_donation_app/utilities/app_extensions.dart';
import 'package:blood_donation_app/utilities/app_globals.dart';

class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;

  QuranAyatModel? quranAyatRes;
  HadithModel? hadithRes;
  HistoryModel? historyRes;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((d) {
      onRefresh();
    });
  }

  Future<void> getDailyContent() async {
    try {
      AppGlobals.isLoading(true);
      
      final res = await AyatAndHadithService.getDailyContent();
      quranAyatRes = res.ayahs.firstOrNull;
      hadithRes = res.hadiths.firstOrNull;
      historyRes = res.histories.firstOrNull;
      update(["quranAyat", "hadith", "history"]);
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future<void> getQuranAyat() async {
    try {
      AppGlobals.isLoading(true);
      quranAyatRes = await AyatAndHadithService.getDailyAyat();
      update(["quranAyat"]);
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future<void> getDailyHadith() async {
    try {
      AppGlobals.isLoading(true);
      hadithRes = await AyatAndHadithService.getDailyHadith();
      update(["hadith"]);
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future<void> getDailyHistory() async {
    try {
      AppGlobals.isLoading(true);
      historyRes = await AyatAndHadithService.getDailyHistory();
      update(["history"]);
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  onRefresh() {
    getDailyContent();
  }

  Future<void> addToFavorite(String? id) async {
    try {
      if (id.isNullOREmpty) return;
      AppGlobals.isLoading(true);
      await Future.delayed(Duration(milliseconds: 500));

      switch (currentTabIndex.value) {
        case 0:
          await FavoriteService.addAyatToFavorite(id!);
          quranAyatRes?.isFavorite = true;
          update(["quranAyat"]);
          break;
        case 1:
          await FavoriteService.addHadithToFavorite(id!);
          hadithRes?.isFavorite = true;
          update(["hadith"]);
          break;
        case 2:
          await FavoriteService.addHistoryToFavorite(id!);
          historyRes?.isFavorite = true;
          update(["history"]);
          break;
        default:
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future<void> removeFromFavorite(String? id) async {
    try {
      if (id.isNullOREmpty) return;
      AppGlobals.isLoading(true);
      await Future.delayed(Duration(milliseconds: 500));
      switch (currentTabIndex.value) {
        case 0:
          await FavoriteService.removeAyatFromFavorite(id!);
          quranAyatRes?.isFavorite = false;
          update(["quranAyat"]);
          break;
        case 1:
          await FavoriteService.removeHadithFromFavorite(id!);
          hadithRes?.isFavorite = false;
          update(["hadith"]);
          break;
        case 2:
          await FavoriteService.removeHistoryFromFavorite(id!);
          historyRes?.isFavorite = false;
          update(["history"]);
          break;
        default:
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }
}
