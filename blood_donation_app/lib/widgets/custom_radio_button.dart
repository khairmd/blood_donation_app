import 'package:blood_donation_app/utilities/app_exports.dart';

class CustomRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Color? activeColor;
  final Color? outLineColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry? margin;
  final double radioSize;
  final double activeCircleSize;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
    this.outLineColor,
    this.shadowColor,
    this.margin,
    this.radioSize = 22,
    this.activeCircleSize = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        width: radioSize,
        height: radioSize,
        margin: margin ?? const EdgeInsetsDirectional.only(end: 10, top: 12, bottom: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.scaffoldBackground,
          border: Border.all(color: outLineColor ?? Colors.grey.shade500, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.transparent,
              blurRadius: 22,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: AnimatedContainer(
          width: value == groupValue ? radioSize / activeCircleSize : 0,
          height: value == groupValue ? radioSize / activeCircleSize : 0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(shape: BoxShape.circle, color: activeColor),
        ),
      ),
    );
  }
}
