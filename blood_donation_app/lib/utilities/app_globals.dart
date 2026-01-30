import 'dart:async';
import 'dart:io';
import 'dart:math' hide log;
import 'package:flutter/cupertino.dart';
import 'app_exports.dart';

class AppGlobals {
  static RxBool isLoading = false.obs;
  static RxBool isDarkMode = true.obs; // Observable boolean for dark mode

  ///
  /// VARIABLES
  ///
  static final GlobalKey<NavigatorState> appNavigationKey =
      GlobalKey<NavigatorState>();
  static bool isLogin = false;
  static String fcmToken = "";
  static final int selectedIndex = 0;

  ///
  /// FUNCTIONS
  ///

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  static final Random _rnd = Random();

  static String getInitials(String bankAccountName) =>
      bankAccountName.isNotEmpty
          ? bankAccountName
              .trim()
              .split(RegExp(' +'))
              .map((s) => s[0])
              .take(2)
              .join()
          : '';

  /// Return device based dimension
  static double getNormDim(double androidDimension, double iOSDimension) {
    if (Platform.isAndroid) {
      return androidDimension;
    } else {
      return iOSDimension;
    }
  }

  static String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );

  static DateTime parseToDateTime(
    String dateTime,
    String incomingFormat,
    String outgoingFormat,
  ) {
    var incomingDateTime = DateFormat(incomingFormat).parse(dateTime);
    var outgoingDateTime = DateFormat(
      outgoingFormat,
    ).parse(incomingDateTime.toString());
    return outgoingDateTime;
  }

  static showErrorSnackBar({
    String? heading,
    required String message,
    bool closeDialog = false,
  }) {
    if (Get.context == null) return;
    if (Get.isDialogOpen! && closeDialog) Get.back();
    Get.snackbar(
      "Error",
      message,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.TOP,
      maxWidth: 500,
      margin: const EdgeInsets.only(top: 20),
    );
  }

  static showSuccessSnackBar({
    String? heading,
    required String message,
    int durationMilliSec = 3000,
  }) {
    if (Get.context == null) return;
    Get.snackbar(
      heading ?? 'Success',
      message,
      colorText: AppColors.primary,
      backgroundColor: AppColors.borderColor,
      snackPosition: SnackPosition.TOP,
      icon: Icon(Icons.check_circle_sharp, color: AppColors.borderColor),
      duration: Duration(milliseconds: durationMilliSec),
    );
  }

  static showAlertDialog({
    String? heading,
    required String message,
    bool closeDialog = false,
    bool dismissible = false,
    String? btnText,
    VoidCallback? onTap,
  }) {
    if (Get.context == null) return;
    if (Get.isDialogOpen! && closeDialog) Get.back();
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(heading ?? 'Error'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              // Navigator.of(context).pop();
              Get.back();
            },
          ),
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: dismissible,
    );
  }

  static showSimpleDialog({
    required BuildContext context,
    required String title,
    String btnText = 'Select',
    required Widget content,
    required VoidCallback onBtnTap,
    bool isBarrierDismissible = true,
  }) {
    showDialog(
      barrierDismissible: isBarrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextTheme.bodyLarge),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close button action
                      },
                      child: const Icon(
                        CupertinoIcons.xmark,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Divider
                Divider(color: AppColors.dividerColor),
                Flexible(child: content),
                const SizedBox(height: 16),
                // Footer
                btnText == 'Select' || btnText == 'Create Notes'
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomRoundedButton(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            textColor: Colors.black,
                            buttonColor: Colors.white,
                            onTap: () => Get.back(),
                            text: 'Cancel',
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: CustomRoundedButton(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            onTap: onBtnTap,
                            text: btnText,
                          ),
                        ),
                      ],
                    )
                    : CustomRoundedButton(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 40,
                      width: double.maxFinite,
                      onTap: onBtnTap,
                      text: btnText,
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showSuccessDialog({
    required BuildContext context,
    required String heading,
    required String title,
    String btnText = 'Ok',
    required VoidCallback onBtnTap,
    bool isBarrierDismissible = true,
  }) {
    showDialog(
      barrierDismissible: isBarrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: (Get.context?.isTablet ?? false) ? 500 : 300,
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    CustomText(
                      heading,
                      style: AppTextTheme.bodyLarge,
                      maxLine: (Get.context?.isTablet ?? false) ? 1 : 2,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      title,
                      style: AppTextTheme.bodyLarge,
                      maxLine: (Get.context?.isTablet ?? false) ? 2 : 3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Footer
                    CustomRoundedButton(
                      padding:
                          (Get.context?.isTablet ?? false)
                              ? EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              )
                              : EdgeInsets.symmetric(horizontal: 8),
                      height: (Get.context?.isTablet ?? false) ? 50 : 40,
                      width: (Get.context?.isTablet ?? false) ? 200 : 150,
                      buttonColor: AppColors.borderColor,
                      onTap: onBtnTap,
                      text: btnText,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: (Get.context?.isTablet ?? false) ? -50 : -30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEBE7E0),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.thumb_up,
                      color: Color(0xffB8946A),
                      size: (Get.context?.isTablet ?? false) ? 50 : 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static deleteDialog({
    required BuildContext context,
    required String title,
    String? msg,
    String btnText = 'Delete',
    double btnWidth = 147.5,
    bool showCancelButton = true,
    double cancelButtonWidth = 147.5,
    required deleteBtnTap,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 100,
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(title, style: AppTextTheme.bodyLarge),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close button action
                      },
                      child: const Icon(
                        CupertinoIcons.xmark,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColors.dividerColor),
                const SizedBox(height: 16),
                Text(
                  msg ??
                      "Do you really want to delete this record? This process cannot be undone.",
                  style: AppTextTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showCancelButton
                        ? CustomRoundedButton(
                          width: cancelButtonWidth,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 40,
                          textColor: Colors.black,
                          buttonColor: Colors.white,
                          onTap: () {
                            Get.back();
                          },
                          text: 'Cancel',
                        )
                        : SizedBox(),
                    Flexible(
                      child: CustomRoundedButton(
                        width: btnWidth,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 40,
                        onTap: deleteBtnTap,
                        text: btnText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static statusDialog({required String title}) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 120,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        title == 'Activated'
                            ? AppConstants.mail
                            : AppConstants.mail,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 10,
                        color: AppColors.secondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Employee has been $title Successfully!',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                    ),
                    child: Text(
                      'Done',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final DateTime selectedDate = DateTime.now();
  final TimeOfDay selectedTime = TimeOfDay.now();

  Future<DateTime> selectDate(
    BuildContext context, {
    bool isFilterDialog = false,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: lastDate ?? DateTime(2101),
      confirmText: isFilterDialog ? 'Apply Filter' : 'Ok',
      cancelText: isFilterDialog ? '' : 'Cancel',
      builder: (context, child) {
        // return child!;
        return Theme(
          data: AppTheme.lightTheme,
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      return picked;
    }
    return selectedDate;
  }

  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
            textTheme: TextTheme(
              headlineMedium: const TextStyle(fontSize: 16.0),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      return picked;
    }
    return selectedTime;
  }

  static String? formatDate(DateTime? date) {
    if(date == null){
      return null;
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String toISOFormatDate(String dateString) {
    // Parse the input date string to a DateTime object
    DateTime dateTime = DateFormat('dd MMM yyyy').parse(dateString);

    // Format the DateTime object to the desired format (YYYY-MM-DD)
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  static String formatTime(String timeString) {
    DateFormat inputFormat = DateFormat(
      'HH:mm:ss',
    ); // Assumes 24-hour format input
    DateFormat outputFormat = DateFormat('h:mm a'); // Output as h:mm AM/PM

    try {
      DateTime dateTime = inputFormat.parse(timeString);
      return outputFormat.format(dateTime);
    } catch (e) {
      return "Invalid time format"; // Handle parsing errors
    }
  }

  static String toISOFormatTime(String timeString) {
    // Parse the input time string to a DateTime object
    DateTime dateTime = DateFormat('h:mm a').parse(timeString);

    // Format the DateTime object to the desired format (HH:MM:SS)
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

    return formattedTime;
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  static String formatTimeOfDayToHHMMSS(
    TimeOfDay timeOfDay, {
    int seconds = 0,
  }) {
    // Ensure seconds are within the valid range (0-59)
    seconds = seconds.clamp(0, 59);

    // Format hours, minutes, and seconds to two digits
    String hours = timeOfDay.hour.toString().padLeft(2, '0');
    String minutes = timeOfDay.minute.toString().padLeft(2, '0');
    String secs = seconds.toString().padLeft(2, '0');

    // Combine into hh:mm:ss format
    return '$hours:$minutes:$secs';
  }

  static String getTimeStamp({required String type}) {
    if (type.toLowerCase() == "tz") {
      return DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      ).format(DateTime.now().toUtc());
    } else if (type.toLowerCase() == "dt_name") {
      return DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now().toUtc());
    } else if (type.toLowerCase() == "dt") {
      /* if(getCurrentLocale()){
        return DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now());
      }*/
      return DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    } else if (type.toLowerCase() == "dt2") {
      return DateFormat('dd/MMM/yyyy hh:mm:ss').format(DateTime.now());
    } else if (type.toLowerCase() == "dt_save") {
      return DateFormat('ddMMyyyy_hhmm').format(DateTime.now());
    } else {
      return "none";
    }
    // debugPrint(DateTime.now().toUtc().toIso8601String());
    // debugPrint(DateTime.now().toString());
    // debugPrint(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()));
  }

  static dynamic convertTimeToLocal({required String utcTime}) {
    if (utcTime != "") {
      return DateFormat(
        "yyyy-MM-dd",
      ).parse(utcTime, true).toLocal().toString().split(" ").first;
      // return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime.toLocal());
    }
    return "";
  }

  static dynamic convertUtcTimeToLocalTIme({required String utcTime}) {
    if (utcTime != "") {
      return formatTime(
        DateFormat(
          "yyyy-MM-dd HH:mm:ss",
        ).parse(utcTime, true).toLocal().toString().split(" ").last,
      );
      // return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime.toLocal());
    }
    return "";
  }

  static dynamic convertTimeToLocalWithT({required String utcTime}) {
    if (utcTime != "") {
      return DateFormat(
        "yyyy-MM-dd",
      ).parse(utcTime, true).toLocal().toString().split(" ").first;
      // return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime.toLocal());
    }
    return "";
  }

  static String convertToHumanReadable(String text) {
    return text
        .replaceAll(
          RegExp(r'[^a-zA-Z0-9]'),
          ' ',
        ) // Replace all non-alphanumeric characters with spaces
        .split(' ') // Split the string by spaces
        .where(
          (word) => word.isNotEmpty,
        ) // Remove any empty words caused by multiple spaces
        .map(
          (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
        ) // Capitalize each word
        .join(' '); // Join the words back with a single space
  }

  static String getCurrencySymbolFromCode(String code) {
    var format = NumberFormat.simpleCurrency(
      locale: Platform.localeName,
      name: code.toUpperCase(),
    );
    return format.currencySymbol;
  }

  static String convertTimeIntoUTC({String? date, required String? time}) {
    String dateString =
        "$date ${AppGlobals.toISOFormatTime(time!)}"; // Example input
    DateTime parsedDate = DateTime.parse(dateString);
    DateTime utcTime = parsedDate.toUtc();

    String fetchTime = utcTime.toString().split(" ").last;
    String convertedUtcTime = fetchTime.split(".").first;
    if (kDebugMode) {
      print("Parsed Local Time: $parsedDate");
      print("Converted UTC Date Time: $utcTime");
      print("Converted UTC Time: $utcTime");
      print("UTC Time: $convertedUtcTime");
    }

    return convertedUtcTime;
  }

  static showScaffold(String toastMsg) {
    ScaffoldMessenger.of(
      appNavigationKey.currentContext!,
    ).showSnackBar(SnackBar(content: Text(toastMsg)));
  }

  Timer? _debounce;

  void onDebounce(String query, void Function() function) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel(); // Cancel the previous timer
    }
    _debounce = Timer(const Duration(seconds: 1), function);
  }
}
