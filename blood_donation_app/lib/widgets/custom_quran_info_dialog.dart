import 'package:blood_donation_app/utilities/app_exports.dart';

Future<void> showQuranInfoDialog(
  BuildContext context, {
  String? quranDialogTitle, // e.g., "Quran"
  String? quranDialogTitleArabic, // e.g., "القرآن"
  String? contentTitle, // e.g., "Surah Al-Mulk"
  String? contentTitleArabic, // e.g., "الملك"
  String? englishContent,
  String? arabicContent, // We'll just display this as text for now
  DateTime? date,
  bool showLanguageSelectionButton = true,
  String? selectedLanguage,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // Allow dismissing by tapping outside
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: AppColors.dialogBgColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: QuranDialogContent(
          quranDialogTitle: quranDialogTitle,
          quranDialogTitleArabic: quranDialogTitleArabic,
          contentTitle: contentTitle,
          contentTitleArabic: contentTitleArabic,
          englishContent: englishContent,
          arabicContent: arabicContent,
          date: date,
          showLanguageSelectionButton: showLanguageSelectionButton,
          selectedLanguage: selectedLanguage,
        ),
      );
    },
  );
}

// --- The content widget for the dialog (Stateful for language toggle) ---
class QuranDialogContent extends StatefulWidget {
  final String? quranDialogTitle;
  final String? quranDialogTitleArabic;
  final String? contentTitle;
  final String? contentTitleArabic;
  final String? englishContent;
  final String? arabicContent;
  final DateTime? date;
  final bool showLanguageSelectionButton;
  final String? selectedLanguage;

  const QuranDialogContent({
    super.key,
    this.quranDialogTitle,
    this.quranDialogTitleArabic,
    this.contentTitle,
    this.contentTitleArabic,
    this.englishContent,
    this.arabicContent,
    this.date,
    this.showLanguageSelectionButton = true,
    this.selectedLanguage,
  });

  @override
  _QuranDialogContentState createState() => _QuranDialogContentState();
}

class _QuranDialogContentState extends State<QuranDialogContent> {
  String _selectedLanguage = 'English'; // Default selected language

  bool get isEnglishSelected => _selectedLanguage == 'English';

  @override
  void initState() {
    super.initState();
    if (widget.selectedLanguage != null) {
      _selectedLanguage = widget.selectedLanguage!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = widget.date.toFormatDateTime();
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.primary;

    return Stack(
      clipBehavior: Clip.none, // Allow close button to overflow if needed
      children: [
        Container(
          padding: EdgeInsets.all(20.0.r),
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important for dialogs
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment:
                    isEnglishSelected ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  CustomText(
                    isEnglishSelected ? widget.quranDialogTitle : widget.quranDialogTitleArabic,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (widget.showLanguageSelectionButton) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.dialogBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildLanguageButton('English', activeColor, inactiveColor),
                      const SizedBox(width: 10),
                      _buildLanguageButton('Arabic', activeColor, inactiveColor),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Row(
                mainAxisAlignment:
                    isEnglishSelected ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  CustomText(
                    isEnglishSelected ? widget.contentTitle : widget.contentTitleArabic,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    maxLine: 4,
                    textDirection: isEnglishSelected ? TextDirection.ltr : TextDirection.rtl,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Divider(color: AppColors.strokeColor, thickness: 0.5),
              const SizedBox(height: 5),
              Flexible(
                // Allows SingleChildScrollView to take available space
                child: RawScrollbar(
                  scrollbarOrientation:
                      isEnglishSelected ? ScrollbarOrientation.right : ScrollbarOrientation.left,
                  thumbColor: AppColors.primary,
                  thickness: 4,
                  radius: Radius.circular(8.r),
                  interactive: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      right: isEnglishSelected ? 10 : 0,
                      left: isEnglishSelected ? 0 : 10,
                    ),

                    child: Row(
                      mainAxisAlignment:
                          isEnglishSelected ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomText(
                            _selectedLanguage == 'English'
                                ? widget.englishContent
                                : widget.arabicContent,
                            textAlign:
                                _selectedLanguage == 'Arabic' ? TextAlign.right : TextAlign.left,
                            textDirection:
                                _selectedLanguage == 'Arabic'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            maxLine: 100,
                            height: _selectedLanguage == 'Arabic' ? 2 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomText(formattedDate, fontSize: 16, fontWeight: FontWeight.w500),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: isEnglishSelected ? 10 : null,
          left: isEnglishSelected ? null : 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageButton(String language, Color activeColor, Color inactiveColor) {
    bool isActive = _selectedLanguage == language;
    return SizedBox(
      height: 28.h,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? activeColor : AppColors.dialogBgColor,
          foregroundColor: isActive ? Colors.white : inactiveColor,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          textStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          elevation: 0,
        ),
        child: Text(language),
      ),
    );
  }
}
