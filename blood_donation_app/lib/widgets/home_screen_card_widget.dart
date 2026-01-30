import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_quran_info_dialog.dart';

class HomeScreenCardWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String? titleArabic;
  final String? dialogTitle;
  final String? dialogTitleArabic;
  final bool? isFavorite;
  final bool showSahihText;
  final String? arabicText;
  final String? englishText;
  final String? detailText;
  final DateTime? dateTime;
  final int? maxLine;
  final void Function()? onInfoTap;
  final void Function()? onFavoriteIconTap;
  final bool centerTitle;
  final num? ayatNumber;
  const HomeScreenCardWidget({
    super.key,
    required this.icon,
    this.title,
    this.titleArabic,
    this.dialogTitle,
    this.dialogTitleArabic,
    this.isFavorite,
    this.arabicText,
    this.englishText,
    this.detailText,
    this.dateTime,
    this.maxLine,
    this.onInfoTap,
    this.showSahihText = true,
    this.onFavoriteIconTap,
    this.centerTitle = false,
    this.ayatNumber,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.homeScreenCardBgColor,
        border: Border.all(color: AppColors.strokeColor),
      ),
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface),
                  ),
                  padding: const EdgeInsets.all(6.0),
                  height: 30.h,
                  width: 30.h,

                  child: CustomImageView(
                    imagePath: icon,
                    color: AppColors.surface,
                    fit: BoxFit.contain,
                  ),
                ),
                10.horizontalSpace,
                Container(
                  constraints: BoxConstraints(maxWidth: size.width * 0.5),
                  child: CustomText(title ?? '', fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                if (ayatNumber != null) ...[
                  4.horizontalSpace,
                  CustomText(
                    "($ayatNumber)",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ],
                8.horizontalSpace,
                InkWell(
                  onTap: onInfoTap,
                  child: Icon(Icons.info_outline, color: AppColors.primary),
                ),
                Spacer(),
                CustomImageView(
                  imagePath:
                      isFavorite == true
                          ? AppConstants.favoriteFillIcon
                          : AppConstants.favoriteUnFillIcon,
                  color: AppColors.favoriteColor,
                  height: 24.sp,
                  onTap: onFavoriteIconTap,
                ),
              ],
            ),
          ),
          Divider(color: AppColors.strokeColor, thickness: 1),
          if (arabicText.isNotNullAndNotEmpty) ...[
            GestureDetector(
              onTap: () {
                showQuranInfoDialog(
                  context,
                  quranDialogTitleArabic: dialogTitleArabic,
                  showLanguageSelectionButton: false,
                  contentTitleArabic: titleArabic,
                  arabicContent: arabicText,
                  selectedLanguage: "Arabic",
                  date: dateTime ?? DateTime.now(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment:
                      centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        arabicText ?? '',
                        maxLine: 2,
                        textDirection: TextDirection.rtl,
                        textAlign: centerTitle ? TextAlign.center : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.strokeColor, thickness: 1),
          ],
          if (englishText.isNotNullAndNotEmpty) ...[
            GestureDetector(
              onTap: () {
                showQuranInfoDialog(
                  context,
                  quranDialogTitle: dialogTitle,
                  showLanguageSelectionButton: false,
                  contentTitle: title,
                  englishContent: englishText,
                  selectedLanguage: "English",
                  date: dateTime ?? DateTime.now(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment:
                      centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        englishText ?? '',
                        maxLine: 2,
                        textAlign: centerTitle ? TextAlign.center : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.strokeColor, thickness: 1),
          ],
          if (detailText.isNotNullAndNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment:
                    centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  if (showSahihText) CustomText('Sahih', color: AppColors.primary),
                  GestureDetector(
                    onTap: () {
                      showQuranInfoDialog(
                        context,
                        quranDialogTitle: dialogTitle,
                        showLanguageSelectionButton: false,
                        contentTitle: title,
                        englishContent: detailText,
                        selectedLanguage: "English",
                        date: dateTime ?? DateTime.now(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                          centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            detailText ?? '',
                            maxLine: maxLine ?? 2,
                            textAlign: centerTitle ? TextAlign.center : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      CustomText(
                        (dateTime ?? DateTime.now()).toFormatDateTime(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
