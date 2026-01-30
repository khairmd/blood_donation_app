import 'package:blood_donation_app/screens/favorite_screen/favorite_screen_controller.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_quran_info_dialog.dart';
import 'package:blood_donation_app/widgets/custom_tab_widget.dart';
import 'package:blood_donation_app/widgets/home_screen_card_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  FavoriteScreenController get controller => Get.put(FavoriteScreenController());

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: controller,
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((d) {
          controller.onRefresh();
        });
      },
      builder: (_) {
        return CustomLoader(
          isTrue: AppGlobals.isLoading.value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.searchController,
                  upperLabel: "",
                  upperLabelReqStar: "",
                  hintValue: "Search",
                  borderColor: AppColors.primary,
                  outerPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    controller.onSearch(value);
                  },
                  prefixIcon: CustomImageView(
                    imagePath: AppConstants.searchIcon,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
                10.verticalSpace,
                Obx(() {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: 48.h,

                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primary, width: 1),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.zero,
                      tabs: [
                        CustomTab(
                          imagePath: AppConstants.quranIcon,
                          title: "Quran",
                          isSelected: controller.currentTabIndex.value == 0,
                        ),
                        CustomTab(
                          imagePath: AppConstants.hadithIcon,
                          title: "Hadith",
                          isSelected: controller.currentTabIndex.value == 1,
                        ),
                        CustomTab(
                          imagePath: AppConstants.quranIcon,
                          title: "History",
                          isSelected: controller.currentTabIndex.value == 2,
                        ),
                      ],
                      isScrollable: false,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      onTap: (value) {
                        controller.currentTabIndex.value = value;
                        controller.update();
                      },
                    ),
                  );
                }),
                10.verticalSpace,

                Expanded(
                  child: GetBuilder(
                    init: controller,
                    builder: (_) {
                      int itemCount =
                          controller.currentTabIndex.value == 0
                              ? controller.favoriteAyat.length
                              : controller.currentTabIndex.value == 1
                              ? controller.favoriteHadith.length
                              : controller.favoriteHistory.length;
                      if (itemCount == 0) {
                        return Center(
                          child: CustomText(
                            "No data found",
                            color: AppColors.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: itemCount,
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        separatorBuilder: (context, index) {
                          return 10.verticalSpace;
                        },
                        itemBuilder: (context, index) {
                          return Obx(() {
                            switch (controller.currentTabIndex.value) {
                              case 0:
                                return HomeScreenCardWidget(
                                  icon: AppConstants.quranIcon,
                                  dialogTitle: "Quran",
                                  dialogTitleArabic: "القرآن",
                                  titleArabic: "سورة الملك(٦٧ )",
                                  title: controller.favoriteAyat[index].ayah?.surahName ?? "-",
                                  arabicText:
                                      controller.favoriteAyat[index].ayah?.textArabic ?? "-",
                                  englishText:
                                      controller.favoriteAyat[index].ayah?.textRoman ?? "-",
                                  detailText:
                                      controller.favoriteAyat[index].ayah?.textEnglish ?? "-",
                                  centerTitle: true,
                                  isFavorite: true,
                                  dateTime:
                                      controller.favoriteAyat[index].ayah?.publishDate ??
                                      DateTime.now(),

                                  onFavoriteIconTap:
                                      () => controller.onFavoriteIconTap(
                                        controller.favoriteAyat[index].ayah?.id,
                                      ),
                                  onInfoTap:
                                      () => showQuranInfoDialog(
                                        context,
                                        quranDialogTitle: "Quran",
                                        quranDialogTitleArabic: "القرآن",
                                        contentTitle:
                                            controller.favoriteAyat[index].ayah?.surahName ?? "-",
                                        contentTitleArabic: "سورة الملك(٦٧ )",
                                        englishContent:
                                            controller
                                                .favoriteAyat[index]
                                                .ayah
                                                ?.detailEnglishPopup ??
                                            "-",
                                        arabicContent:
                                            controller
                                                .favoriteAyat[index]
                                                .ayah
                                                ?.detailArabicPopup ??
                                            "-",
                                        date:
                                            controller.favoriteAyat[index].ayah?.dateAdded ??
                                            DateTime.now(),
                                      ),
                                );
                              case 1:
                                return HomeScreenCardWidget(
                                  dialogTitle: "Hadith",
                                  dialogTitleArabic: "الحديث",
                                  titleArabic: "تجنب الشكوك",
                                  icon: AppConstants.hadithIcon,
                                  title: controller.favoriteHadith[index].hadith?.title ?? "-",
                                  arabicText:
                                      controller.favoriteHadith[index].hadith?.arabicText ?? "-",
                                  englishText:
                                      controller.favoriteHadith[index].hadith?.englishTranslation ??
                                      "-",
                                  detailText:
                                      controller.favoriteHadith[index].hadith?.sahihReference ??
                                      "-",
                                  dateTime:
                                      controller.favoriteHadith[index].hadith?.publishDate ??
                                      DateTime.now(),
                                  isFavorite: true,
                                  centerTitle: true,
                                  onFavoriteIconTap:
                                      () => controller.onFavoriteIconTap(
                                        controller.favoriteHadith[index].hadith?.id,
                                      ),

                                  onInfoTap:
                                      () => showQuranInfoDialog(
                                        context,

                                        quranDialogTitle: "Hadith",
                                        quranDialogTitleArabic: "الحديث",
                                        contentTitle:
                                            controller.favoriteHadith[index].hadith?.title ?? "-",
                                        contentTitleArabic: "تجنب الشكوك",
                                        englishContent:
                                            controller.favoriteHadith[index].hadith?.explanation ??
                                            "-",
                                        arabicContent:
                                            controller.favoriteHadith[index].hadith?.arabicText ??
                                            "-",
                                        date:
                                            controller.favoriteHadith[index].hadith?.updatedAt ??
                                            DateTime.now(),
                                      ),
                                );
                              case 2:
                                return HomeScreenCardWidget(
                                  dialogTitle: "History",
                                  icon: AppConstants.historyIcon,
                                  title: controller.favoriteHistory[index].history?.title ?? "-",
                                  maxLine: 7,
                                  detailText:
                                      controller.favoriteHistory[index].history?.detail ?? "-",
                                  dateTime:
                                      controller.favoriteHistory[index].history?.publishDate ??
                                      DateTime.now(),
                                  showSahihText: false,
                                  isFavorite: true,
                                  centerTitle: true,
                                  onFavoriteIconTap:
                                      () => controller.onFavoriteIconTap(
                                        controller.favoriteHistory[index].history?.id,
                                      ),

                                  onInfoTap:
                                      () => showQuranInfoDialog(
                                        context,
                                        quranDialogTitle: "History",
                                        quranDialogTitleArabic: "تاريخ",
                                        contentTitle:
                                            controller.favoriteHistory[index].history?.title ?? "-",
                                        contentTitleArabic: "معاهدة الحديبية",
                                        englishContent:
                                            controller.favoriteHistory[index].history?.title ?? "-",
                                        showLanguageSelectionButton: false,
                                        date:
                                            controller.favoriteHistory[index].history?.updatedAt ??
                                            DateTime.now(),
                                      ),
                                );
                              default:
                                return SizedBox.shrink();
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
