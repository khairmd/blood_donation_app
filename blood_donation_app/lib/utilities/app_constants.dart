class AppConstants {
  // Private Constructor to Prevent Instantiation

  AppConstants._();

  // Static Constant Fields

  static const double padding = 15;

  static const String icons = 'assets/icons';

  static const String images = 'assets/images';

  ///Images
  static const String home='$images/created_new_image_.jpg';
  static const String splashBgLight = '$images/splash_bg_light.png';
  static const String splashBgDark = '$images/splash_bg_dark.png';
  static const String singInBgLight = '$images/sign_in_bg_light.png';
  static const String singInBgDark = '$images/sign_up_bg_dark.png';
  static const String singUpBgLight = '$images/sign_up_bg_light.png';
  static const String singUpBgDark = '$images/sign_up_bg_dark.png';
  static const String forgetPassBgLight = '$images/sign_up_bg_dark.png';
  static const String forgetPassBgDark = '$images/sign_up_bg_dark.png';
  static const String otpCodeBgLight = '$images/sign_up_bg_dark.png';
  static const String otpCodeBgDark = '$images/sign_up_bg_dark.png';
  static const String passResetSuccessBgLight = '$images/sign_up_bg_dark.png';
  static const String passResetSuccessBgDark = '$images/sign_up_bg_dark.png';
  static const String resetPassBgLight = '$images/sign_up_bg_dark.png';
  static const String resetPassBgDark = '$images/sign_up_bg_dark.png';
  static const String quizBgLight = '$images/sign_up_bg_dark.png';
  static const String quizBgDark = '$images/sign_up_bg_dark.png';
  static const String illustration = '$icons/sign_up_bg_dark.png';
  static const String homeBgImage = '$images/sign_up_bg_dark.png';
  static const String homeBgDarImage = '$images/sign_up_bg_dark.png';
  static const String homeTileBgImage = '$images/sign_up_bg_dark.png';
  static const String homeTileBgDarkImage = '$images/sign_up_bg_dark.png';
  static const String welcomeBannerImage = '$images/sign_up_bg_dark.png';
  static const String customDialogBgImage = '$images/sign_up_bg_dark.png';
  static const String customDialogBgDarkImage = '$images/sign_up_bg_dark.png';
  static const String answerDialogImage='$images/answer_dialog_image.png';
  static const String resultImage='$images/result_image.png';
  static const String profileBgLight = '$images/profile_bg_light.png';
  static const String profileBgDark = '$images/profile_bg_dark.png';
  static const String createJournalBgDarkImage = '$images/create_journal_bg_dark_image.png';
  static const String createJournalBgImage = '$images/create_journal_bg_image.png';
  static const String journalBgDarkImage = '$images/journal_bg_dark_image.png';
  static const String journalBgImage = '$images/journal_bg_image.png';
  static const String reminderBgImage = '$images/reminder_bg_image.png';
  static const String reminderBgDarkImage = '$images/reminder_bg_dark_image.png';
  static const String subscriptionImage = '$images/sign_up_bg_dark.png';
  static const String subscriptionDarkImage = '$images/sign_up_bg_dark.png';
  static const String calendarBgImage = '$images/calendar_bg_image.png';
  static const String bloodBag='$images/sign_up_bg_dark.png';


  ///Icons
  static const String profile = '$icons/profile-circle.svg';
  static const String mail = '$icons/mail.svg';
  static const String lock = '$icons/lock.svg';
  static const String calendar = '$icons/calendar.svg';
  static const String gender = '$icons/gender_icon.svg';
  static const String apple = '$icons/apple.svg';
  static const String google = '$icons/google.svg';
  static const String eye = '$icons/eye.svg';
  static const String eyeSlash = '$icons/eye-slash.svg';
  static const String leftLine = '$icons/left-line.svg';
  static const String rightLine = '$icons/right-line.svg';
  static const String notification = '$icons/notification.svg';
  static const String deleteAccount = '$icons/delete_account_icon.svg';
  static const String profilePlaceHolder = '$icons/profile_placeholder.png';
  static const String star= '$icons/star.svg';
  static const String quizIcon2= '$icons/quiz_icon2.svg';

  static const String logo = '$icons/app_logo.png';

  static const String clockIcon = '$icons/clock.png';

  static const String calendarIcon = '$icons/calendar.png';

  static const String homeIcon = '$icons/home_icon.png';

  static const String profileIcon = '$icons/profile-circle.png';
  static const String person = '$icons/profile-circle.png';
  static const String menuIcon = '$icons/menu_icon.svg';
  static const String quranIcon = '$icons/quran.png';
  static const String hadithIcon = '$icons/hadith.png';
  static const String historyIcon = '$icons/history.png';
  static const String quizIcon = '$icons/quiz_icon.svg';
  static const String quizDarkIcon = '$icons/quiz_dark_icon.svg';
  static const String journalIcon = '$icons/journal_icon.svg';
  static const String journalDarkIcon = '$icons/journal_dark_icon.svg';
  static const String personIcon = '$icons/person_icon.png';
  static const String quizDrawerIcon = '$icons/quiz_icon.png';
  static const String themeIcon = '$icons/theme_icon.png';
  static const String subscriptionIcon = '$icons/subscription_icon.png';
  static const String journalDrawerIcon = '$icons/journal_icon.png';
  static const String settingIcon = '$icons/setting_icon.png';
  static const String logoutIcon = '$icons/logout_icon.png';
  static const String notificationIcon = '$icons/notification_icon.png';
  static const String favoriteIcon = '$icons/favorite_icon.png';
  static const String searchIcon = '$icons/search_icon.png';
  static const String favoriteFillIcon = '$icons/favorite_filled_icon.png';
  static const String favoriteUnFillIcon = '$icons/favorite_unfilled_icon.png';
  static const String trashIcon = '$icons/trash_icon.png';
  static const String celebrationIcon = '$icons/celebration_icon.png';
  static const String journalBookIcon = '$icons/journal_book_icon.png';
  static const String journalBookIconTwo = '$icons/journal_book_icon_2.png';
  static const String clockSvgIcon = '$icons/clock.svg';
  static const String calendarSvgIcon = '$icons/calendar.svg';
  static const String personalCardSvgIcon = '$icons/personal_card.svg';
  static const String editSvgIcon = '$icons/edit-2.svg';
  static const String trashSvgIcon = '$icons/trash.svg';
  static const String reminderCalendarIcon = '$icons/reminder_calendar_icon.png';

  // text-fields input whitelisting

  static const Pattern emailFilterPattern = r'[a-zA-Z0-9@._-]';

  static const Pattern passwordFilterPattern = r'[a-zA-Z0-9!#\$%^&*()=+~`<>,/?:;"|\\@._-]';

  static const Pattern nameFilterPattern = r'[a-zA-Z]+|\s';

  static const Pattern numberFilterPattern = r'[0-9]';

  static const String dateFormat = "dd MMM yyyy";
}
