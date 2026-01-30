import 'package:blood_donation_app/utilities/app_exports.dart';

class CustomTab extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String? imagePath;
  const CustomTab({super.key, this.imagePath, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null) ...[
              CustomImageView(
                imagePath: imagePath,
                height: 18.h,
                color:
                    isSelected
                        ? AppColors.lightColor
                        : (AppGlobals.isDarkMode.value ? AppColors.lightColor : AppColors.grey),
              ),
              4.horizontalSpace,
            ],
            CustomText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  isSelected
                      ? AppColors.lightColor
                      : (AppGlobals.isDarkMode.value ? AppColors.lightColor : AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
