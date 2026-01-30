import 'package:blood_donation_app/screens/quiz/quiz_controller.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_arc_slider.dart';

class DailyQuizView extends StatelessWidget {
  const DailyQuizView({super.key});

  QuizController get controller => Get.find<QuizController>();

  @override
  Widget build(BuildContext context) {
    controller.getDailyQuiz();
    return GetBuilder<QuizController>(
      init: controller, // Initialize the controller for this GetBuilder
      builder: (_) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AppColors.scaffoldBackground,
          appBar: _buildAppBar(context),
          // Extracted AppBar to a separate method
          body: _buildBody(), // Extracted Body to a separate method
        );
      },
    );
  }

  // --- Widget Building Methods ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      text: 'Daily Quiz',
      showBackIcon: true,
      trailingWidget: Obx(
        () => Visibility(
          // Use Obx here since selectedAnswer is an RxString
          visible: controller.selectedOption.value.isNotEmpty,
          child: IconButton(
            onPressed: () => controller.showAnswerDialog(context),
            // Extracted dialog logic
            icon: Row(
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
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppGlobals.isDarkMode.value
                ? AppConstants.quizBgDark
                : AppConstants.quizBgLight,
            fit: BoxFit.cover,
          ),
        ),
        Obx(
          () =>
              controller.isLoading.value
                  ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Use const for performance
                  : _buildQuizContent(), // Extracted quiz content
        ),
      ],
    );
  }

  Widget _buildQuizContent() {
    return GetBuilder<QuizController>(
      id: "dailyQuiz", // Ensure this ID matches the one updated in controller
      builder: (_) {
        if (controller.dailyQuizModel?.questions?.isNotEmpty ?? false) {
          return Stack(
            children: [
              Positioned(
                bottom: 2,
                right: -2,
                left: -2,
                child: GetBuilder<QuizController>(
                  id: 'slider',
                  // Separate ID for the slider if it updates independently
                  builder: (_) {
                    return CustomArcSlider(
                      maxValue:
                          controller.dailyQuizModel?.questions?.length ?? 0,
                      initialValue: controller.initialValue,
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  30.verticalSpace,
                  CustomText(
                    controller.currentQuestion?.text ?? '',
                    style: AppTextTheme.headlineSmall,
                    maxLine: 4,
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  if (controller.currentQuestion?.options?.isNotEmpty ?? false)
                    ..._buildOptionButtons(), // Extracted option buttons
                ],
              ),
            ],
          );
        } else {
          return Center(
            child: CustomText(
              'No Quiz For Today!',
              style: AppTextTheme.titleLarge,
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildOptionButtons() {
    return controller.currentQuestion!.options!.asMap().entries.map((entry) {
      int index = entry.key;
      var option = entry.value;
      bool isSelected = controller.selectedOption.value == option?.text;
      String label = ['A', 'B', 'C', 'D'][index];
      int? indexOfCorrectAnswer; // Use nullable int in case no correct answer is found

      if (controller.currentQuestion != null && controller.currentQuestion!.options != null) {
        for (int i = 0; i < controller.currentQuestion!.options!.length; i++) {
          if (controller.currentQuestion!.options![i]?.isCorrect == true) {
            indexOfCorrectAnswer = i;
            break; // Found it, no need to check further
          }
        }
      }
      String correctLabel = ['A', 'B', 'C', 'D'][indexOfCorrectAnswer??0];

      return GestureDetector(
        onTap: () {
          controller.selectedOptionId.value=option?.id??'';
          controller.selectAnswer(
            label: label,
            correctLabel: correctLabel,
            answer: option?.text ?? '',
          );
        },
        child: Container(
          height: 48,
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primary : AppColors.textFieldFillColor,
            border: Border.all(color: AppColors.textFieldBorderColor),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              8.horizontalSpace,
              Container(
                height: 36,
                width: 36,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? Colors.white : AppColors.textFieldFillColor,
                  border: Border.all(
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    label,
                    style: AppTextTheme.bodyLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: CustomText(
                  option?.text,
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(); // Convert to a list of widgets
  }
}
