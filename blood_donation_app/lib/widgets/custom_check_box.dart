import 'package:blood_donation_app/utilities/app_exports.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final Color? activeColor;
  final Color? outLineColor;
  final Color? shadowColor;
  final Color fillColor;
  final EdgeInsetsGeometry? margin;
  final double checkBoxSize;
  final String? label;
  final TextStyle? labelStyle;
  final bool enabled;
  final double? radius;
  final EdgeInsetsGeometry? padding;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.outLineColor,
    this.shadowColor,
    this.fillColor = Colors.white,
    this.margin,
    this.checkBoxSize = 20,
    this.label,
    this.labelStyle,
    this.enabled = true,
    this.radius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enabled) {
          onChanged(!value);
        }
      },
      child: Row(
        children: [
          Container(
            width: checkBoxSize,
            height: checkBoxSize,
            margin: margin ?? const EdgeInsetsDirectional.only(end: 10, top: 12, bottom: 12),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: fillColor,
              border: Border.all(color: outLineColor ?? Colors.grey.shade500, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 04)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor ?? AppColors.lightColor,
                  blurRadius: 22,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                firstCurve: Curves.fastEaseInToSlowEaseOut,
                secondCurve: Curves.fastLinearToSlowEaseIn,
                firstChild: Icon(
                  Icons.check,
                  color: activeColor,
                  size: checkBoxSize / 1.2,
                  weight: 22,
                ),
                secondChild: Icon(Icons.check, color: Colors.transparent, size: checkBoxSize / 1.2),
                crossFadeState: value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
            ),
          ),
          label.isNotNullAndNotEmpty
              ? Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(label!, style: labelStyle ?? AppTextTheme.titleSmall.copyWith(
                  color: AppColors.textPrimary
                )),
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}
