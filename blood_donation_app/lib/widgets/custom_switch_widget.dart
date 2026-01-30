import 'package:flutter/cupertino.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  final bool isDisabled;
  final Color? disabledColor;
  const CustomSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          value: value,
          activeTrackColor:
              isDisabled
                  ? disabledColor ?? AppColors.greyTextColor
                  : (value ? AppColors.primary : AppColors.greyTextColor),
          inactiveTrackColor: AppColors.greyColor,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
