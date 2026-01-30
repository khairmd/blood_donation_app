import '../utilities/app_exports.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final int? maxLine;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final double? height;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.maxLine = 1,
    this.color,
    this.fontWeight,
    this.overflow,
    this.textAlign,
    this.style,
    this.textDirection,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style:
          style ??
          TextStyle(
            color: color ?? AppColors.textPrimary,
            fontWeight: fontWeight ?? FontWeight.normal,
            fontFamily: AppFonts.primary,
            fontSize: fontSize,
            letterSpacing: 0,
            height: height
          ),
      overflow: overflow ??TextOverflow.ellipsis,
      maxLines: maxLine,
      softWrap: true,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
    );
  }
}
