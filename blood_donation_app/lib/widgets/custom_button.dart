import '../utilities/app_exports.dart';

class CustomRoundedButton extends StatelessWidget {

  const CustomRoundedButton({

    super.key,

    required this.text,

    this.height = 50,

    this.width = 140,

    this.onTap,

    this.padding,

    this.isEnabled = true,

    this.buttonColor,

    this.textColor,

  });

  final double? height;

  final double? width;

  final String text;

  final Color? buttonColor;

  final Color? textColor;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? padding;

  final bool isEnabled;

  @override

  Widget build(BuildContext context) {

    bool isTablet = Get.context?.isTablet ?? false;

    return SizedBox(

      width: width,

      height: height,

      child: ElevatedButton(

        onPressed: isEnabled ? onTap : null,

        style: ElevatedButton.styleFrom(

          padding: padding ?? EdgeInsets.zero,

          backgroundColor: buttonColor ?? AppColors.primary,

          disabledBackgroundColor: AppColors.primary,

          shape: RoundedRectangleBorder(

            side:

                buttonColor != null

                    ? BorderSide(color: AppColors.primary)

                    : BorderSide(

                      color: isEnabled ? AppColors.primary : AppColors.primary,

                      width: 1,

                    ),

            borderRadius: const BorderRadius.all(Radius.circular(50)),

          ),

        ),

        child: CustomText(text, style: AppTextTheme.bodyLarge, fontSize: isTablet ? 0.4 : 1),

      ),

    );

  }

}

class CustomRectangleButton extends StatelessWidget {

  final String text;

  final String? icon;

  final Color? buttonColor;

  final Color? textColor;

  final double? width;

  final VoidCallback? onTap;

  final IconAlignment? iconAlignment;
  
  final Widget? iconWidget;

  const CustomRectangleButton({

    super.key,

    required this.text,

    required this.onTap,

    this.textColor,

    this.width,

    this.buttonColor,

    this.icon,

    this.iconAlignment,

    this.iconWidget,

  });

  @override

  Widget build(BuildContext context) {

    return SizedBox(
      height: 50,
      width: width,

      child: ElevatedButton.icon(

        onPressed: onTap,

        icon: iconWidget ?? ((icon != null && icon != '') ? SvgPicture.asset(icon!) : null),
        iconAlignment: iconAlignment,
        label: CustomText(text, style: AppTextTheme.titleSmall.copyWith(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(8),

            side:

                (text == 'Back' || text == 'Cancel')

                    ? BorderSide(color: AppColors.primary)

                    : BorderSide.none,

          ),

          backgroundColor: buttonColor ?? AppColors.primary,

          // Gold color

          foregroundColor: Colors.white,

          // Text color

          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),

      ),

    );

  }

}

class CustomOutlineButton extends StatelessWidget {

  final String title;

  final VoidCallback onTap;

  final Color? bgColor;

  final Color? textColor;

  final double fontSize;

  final double? width;

  final double? height;

  const CustomOutlineButton({

    super.key,

    required this.title,

    required this.onTap,

    this.width,

    this.height = 44,

    this.fontSize = 14,

    this.bgColor,

    this.textColor,

  });

  @override

  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      child: Container(

        width: width,

        height: height,

        alignment: Alignment.center,

        decoration: BoxDecoration(

          color: bgColor ?? AppColors.primary,

          borderRadius: BorderRadius.circular(8),

          border: Border.all(width: 1.2, color: AppColors.primary),

        ),

        child: Text(

          title,

          style: Theme.of(context).textTheme.bodyMedium!.copyWith(

            color: textColor ?? AppColors.primary,

            fontSize: 16,

            fontWeight: FontWeight.w600,

          ),

        ),

      ),

    );

  }

}
 