import 'package:blood_donation_app/screens/quiz/quiz_binding.dart';
import 'package:blood_donation_app/screens/quiz/views/daily_quiz_history_view.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class CustomQuizAnswerDialog extends StatelessWidget {
  final String question;
  final String givenAnswer;
  final String actualAnswer;
  final String selectedLabel;
  final String actualLabel;
  final String explanation;
  final void Function()? onNextButtonTap;

  const CustomQuizAnswerDialog({
    super.key,
    required this.explanation,
    required this.givenAnswer,
    required this.actualAnswer,
    required this.selectedLabel,
    required this.actualLabel,
    required this.question,
    this.onNextButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.dialogBgColor,
      child: Stack(
        clipBehavior: Clip.none, // Allow close button to overflow if needed
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: AppColors.dialogImageBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: AssetImage(AppConstants.answerDialogImage),
                      fit: BoxFit.contain,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 12.h),
                  child: SvgPicture.asset(
                    AppConstants.illustration,
                    height: 40.h,
                  ),
                ),
                10.verticalSpace,
                CustomText(
                  'Your Answer is ${givenAnswer == actualAnswer ? 'Right' : 'Wrong'}',
                  style: AppTextTheme.titleMedium,
                ),
                Container(
                  height: 48,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        givenAnswer == actualAnswer
                            ? AppColors.primary
                            : AppColors.error,
                    border: Border.all(color: AppColors.textFieldBorderColor),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      SizedBox(),
                      Container(
                        height: 36,
                        width: 36,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: CustomText(
                            selectedLabel,
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          givenAnswer,
                          style: AppTextTheme.bodyLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomText('Correct Answer', style: AppTextTheme.titleMedium),
                Container(
                  height: 48,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    border: Border.all(color: AppColors.textFieldBorderColor),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      SizedBox(),
                      Container(
                        height: 36,
                        width: 36,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: CustomText(
                            actualLabel,
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          actualAnswer,
                          style: AppTextTheme.bodyLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                CustomText(
                  question,
                  style: AppTextTheme.titleMedium,
                  maxLine: 2,
                ),
                8.verticalSpace,
                CustomText(
                  explanation,
                  style: AppTextTheme.bodyLarge.copyWith(
                    color:
                        AppGlobals.isDarkMode.value
                            ? AppColors.lightColor
                            : AppColors.grey500,
                  ),
                  maxLine: 6,
                ),
              ],
            ),
          ),
          Positioned(
            top: 27.h,
            right: 23.h,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onNextButtonTap,
                child: Row(
                  spacing: 8,
                  children: [
                    CustomText(
                      'Next',
                      style: AppTextTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomResultDialog extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final void Function() onViewQuizHistoryButtonTap;

  const CustomResultDialog({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.onViewQuizHistoryButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> filledStars = List.generate(
      correctAnswers,
          (index) => SvgPicture.asset(
        AppConstants.star,
        width: 24, // Optional: specify size
        height: 24, // Optional: specify size
        colorFilter: ColorFilter.mode(Colors.amber, BlendMode.srcIn), // Optional: color the SVG
      ),
    );
    List<Widget> unFilledStars = List.generate(
      totalQuestions-correctAnswers,
          (index) => SvgPicture.asset(
        AppConstants.star,
        key: ValueKey('star_$index'), // Good practice for keys
        width: 24, // Optional: specify size
        height: 24, // Optional: specify size
        colorFilter: ColorFilter.mode(AppColors.darkGreenColor, BlendMode.srcIn), // Optional: color the SVG
      ),
    );
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.dialogBgColor,
      child: Stack(
        clipBehavior: Clip.none, // Allow close button to overflow if needed
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: AppColors.dialogImageBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderColor),
                    image: DecorationImage(
                      image: AssetImage(AppConstants.resultImage),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                10.verticalSpace,
                CustomText(
                  'Quiz Finished',
                  style: AppTextTheme.headlineSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText('Your Rating ', style: AppTextTheme.headlineSmall),
                    ...filledStars,
                    ...unFilledStars,
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xffF9A304),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text('$correctAnswers',style: AppTextTheme.titleMedium.copyWith(fontSize: 18),)),
                        ),
                      ),
                    )
                  ],
                ),
                10.verticalSpace,
                CustomText(
                  'Total Questions $totalQuestions',
                  style: AppTextTheme.headlineSmall,
                  maxLine: 2,
                ),
                5.verticalSpace,
                CustomText(
                  'Answer Right $correctAnswers',
                  style: AppTextTheme.titleMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.greenColor,
                  ),
                  maxLine: 6,
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: CustomRectangleButton(
                        text: 'View Quiz History',
                        onTap: onViewQuizHistoryButtonTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 27.h,
            right: 23.h,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.off(() => DailyQuizHistoryView(),binding: QuizBinding());
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
