import 'dart:io';

import 'package:blood_donation_app/utilities/app_exports.dart';

class Helper {
  /// Return device based dimension
  static double getNormDim(double androidDimension, double iOSDimension) {
    if (Platform.isAndroid) {
      return androidDimension;
    } else {
      return iOSDimension;
    }
  }

  static Future<TimeOfDay?> pickTime(BuildContext context, [TimeOfDay? initialTime]) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return Theme(
          data:
              AppGlobals.isDarkMode.value
                  ? ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(primary: AppColors.primary),
                  )
                  : ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(primary: AppColors.primary),
                  ),
          child: child!,
        );
      },
    );
  }
}
