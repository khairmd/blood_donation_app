import 'dart:async';

import 'package:blood_donation_app/api_core/custom_exception_handler.dart';
import 'package:blood_donation_app/api_services/favorite_service.dart';
import 'package:blood_donation_app/models/favorite_ayat_model.dart';
import 'package:blood_donation_app/models/favorite_hadith_model.dart';
import 'package:blood_donation_app/models/favorite_history_model.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_dialog.dart';

class FavoriteScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;

  List<FavoriteAyahModel> favoriteAyatWhole = [];
  List<FavoriteHadithModel> favoriteHadithWhole = [];
  List<FavoriteHistoryModel> favoriteHistoryWhole = [];

  List<FavoriteAyahModel> favoriteAyat = [];
  List<FavoriteHadithModel> favoriteHadith = [];
  List<FavoriteHistoryModel> favoriteHistory = [];

  Timer? debounce;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  final TextEditingController searchController = TextEditingController();

  void onFavoriteIconTap(String? id) {
    Get.dialog(
      CustomDialog(
        message: "Removing this item will no longer show it in your Favorites list.",
        imageIcon: AppConstants.trashIcon,
        title: "Removed from favorites?",
        btnText: "Remove",
        onButtonTap: () {
          Get.back();
          removeFromFavorite(id);
        },
      ),
    );
  }

  getFavoriteAyat() async {
    try {
      AppGlobals.isLoading(true);
      favoriteAyat = await FavoriteService.getFavoriteAyat();
      favoriteAyatWhole = favoriteAyat.toList();
      update();
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  getFavoriteHadith() async {
    try {
      AppGlobals.isLoading(true);
      favoriteHadith = await FavoriteService.getFavoriteHadith();
      favoriteHadithWhole = favoriteHadith.toList();
      update();
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  getFavoriteHistory() async {
    try {
      AppGlobals.isLoading(true);
      favoriteHistory = await FavoriteService.getFavoriteHistory();
      favoriteHistoryWhole = favoriteHistory.toList();
      update();
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
      await Future.delayed(Duration(milliseconds: 1000));
      switch (currentTabIndex.value) {
        case 0:
          await FavoriteService.removeAyatFromFavorite(id!);
          getFavoriteAyat();
          break;
        case 1:
          await FavoriteService.removeHadithFromFavorite(id!);
          getFavoriteHadith();
          break;
        case 2:
          await FavoriteService.removeHistoryFromFavorite(id!);
          getFavoriteHistory();
          break;
        default:
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  onRefresh() {
    getFavoriteAyat();
    getFavoriteHadith();
    getFavoriteHistory();
  }

  onSearch(String? val) {
    if (val == null) return;
    debounce?.cancel();

    debounce = Timer(Duration(milliseconds: 400), () {
      if (val.isEmpty) {
        favoriteAyat = favoriteAyatWhole.toList();
        favoriteHadith = favoriteHadithWhole.toList();
        favoriteHistory = favoriteHistoryWhole.toList();
      } else {
        favoriteAyat =
            favoriteAyatWhole
                .where(
                  (element) =>
                      element.ayah?.surahName?.toLowerCase().contains(val.toLowerCase()) ?? false,
                )
                .toList();
        favoriteHadith =
            favoriteHadithWhole
                .where(
                  (element) =>
                      element.hadith?.title?.toLowerCase().contains(val.toLowerCase()) ?? false,
                )
                .toList();
        favoriteHistory =
            favoriteHistoryWhole
                .where(
                  (element) =>
                      element.history?.title?.toLowerCase().contains(val.toLowerCase()) ?? false,
                )
                .toList();
      }
      update();
    });
  }
}
