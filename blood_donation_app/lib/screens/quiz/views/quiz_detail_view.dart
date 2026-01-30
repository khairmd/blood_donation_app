import 'package:blood_donation_app/screens/quiz/quiz_controller.dart';
import 'package:readmore/readmore.dart';
import '../../../utilities/app_exports.dart';

class QuizDetailView extends StatelessWidget {
  final String id;

  const QuizDetailView({super.key, required this.id});

  QuizController get controller => Get.find<QuizController>();

  @override
  Widget build(BuildContext context) {
    controller.getQuizResult(id: id);

    return Scaffold(
      appBar: CustomAppBar(
        text: "Quiz Detail",
        centerTitle: true,
        showBackIcon: true,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Quiz Header Card
            _buildQuizHeaderCard(),
            const SizedBox(height: 20),
            // Question & Answer Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                // Added Align for consistent left alignment
                alignment: Alignment.center,
                child: CustomText(
                  'Question & Answer',
                  style: AppTextTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Question Navigation Tabs
            // 3. Use Obx to reactively rebuild the tabs when selectedQuestion changes
            Obx(
              () => _buildQuestionNavigationTabs(
                context,
                controller.selectedQuestion,
              ),
            ),
            const SizedBox(height: 10),
            // Question Answer Card
            // 3. Use Obx to reactively rebuild the card content when selectedQuestion changes
            Obx(() => _buildQuestionAnswerCard(controller.selectedQuestion-1)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizHeaderCard() {
    return Column(
      children: [
        const SizedBox(height: 10),
        GetBuilder(
          init: controller,
          id: 'quizResult',
          builder: (context) {
            return CustomText(
              controller.quizResultModel?.quizTitle ?? '',
              style: AppTextTheme.headlineSmall,
            );
          }
        ),
        const SizedBox(height: 20),
        Container(
          height: 150.h,
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
      ],
    );
  }

  Widget _buildQuestionNavigationTabs(
    BuildContext context,
    int currentSelectedQuestion,
  ) {
    // Get the controller instance to access its methods
    final QuizController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          controller.quizResultModel?.results?.length??0,
          (index) => GestureDetector(
            onTap: () {
              // Call the controller's method to update the selected question
              controller.setSelectedQuestion(index + 1);
            },
            child: _buildQuestionTab(
              context,
              'Q.${index + 1}',
              isSelected:
                  (index + 1) ==
                  currentSelectedQuestion, // Use the passed value
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTab(
    BuildContext context,
    String text, {
    bool isSelected = true,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isSelected
                ? AppColors.textSecondary
                : AppGlobals.isDarkMode.value
                ? Colors.transparent
                : AppColors.lightColor,
        border: Border.all(
          color:
              isSelected
                  ? AppGlobals.isDarkMode.value
                      ? Colors.transparent
                      : AppColors.lightColor
                  : AppColors.textSecondary,
        ),
      ),
      alignment: Alignment.center,
      child: CustomText(
        // Assuming CustomText works with String directly
        text,
        style: AppTextTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.lightColor : AppColors.textSecondary,
        ),
      ),
    );
  }

  // This widget now takes the currently selected question to display dynamic content
  Widget _buildQuestionAnswerCard(int currentQuestionIndex) {
    String questionText =
        controller
            .quizResultModel
            ?.results?[currentQuestionIndex]
            ?.questionText ??
        '';
    String readMoreContent =
        controller
            .quizResultModel
            ?.results?[currentQuestionIndex]
            ?.questionDescription ??
        '';
    String givenAnswer =
        controller
            .quizResultModel
            ?.results?[currentQuestionIndex]
            ?.userAnswer
            ?.text ??
        '';
    String actualAnswer =
        controller
            .quizResultModel
            ?.results?[currentQuestionIndex]
            ?.correctAnswer
            ?.text ??
        '';
    return GetBuilder(
      init: controller,
      id: 'quizResult',
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: AppColors.textFieldFillColor,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Question ${currentQuestionIndex+1}',
                  style: AppTextTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                CustomText(
                  questionText,
                  style: AppTextTheme.headlineSmall,
                  maxLine: 4,
                ),
                const SizedBox(height: 10),
                ReadMoreText(
                  readMoreContent,
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimCollapsedText: 'Read more',
                  trimExpandedText: 'Read less',
                  style: AppTextTheme.bodyLarge,
                  moreStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnswer(givenAnswer: givenAnswer, actualAnswer: actualAnswer),
                const SizedBox(height: 15),
                _buildAnswer(
                  label: 'Correct Answer',
                  givenAnswer: givenAnswer,
                  actualAnswer: actualAnswer,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildAnswer({
    required String actualAnswer,
    required String givenAnswer,
    String? label,
  }) {
    bool isRight = givenAnswer == actualAnswer;
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color:
            AppGlobals.isDarkMode.value
                ? label != null
                    ? AppColors.primary
                    : isRight
                    ? AppColors.primary
                    : AppColors.error.withValues(alpha: 0.23)
                : AppColors.lightGreenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label ?? 'Your Answer ${isRight ? 'Right' : 'Wrong'}',
            style: AppTextTheme.titleMedium,
          ),
          CustomText(
            label != null ? actualAnswer : givenAnswer,
            style: AppTextTheme.headlineSmall.copyWith(
              color:
                  label != null
                      ? AppGlobals.isDarkMode.value
                          ? AppColors.lightColor
                          : AppColors.greenColor
                      : isRight
                      ? AppGlobals.isDarkMode.value
                          ? AppColors.lightColor
                          : AppColors.greenColor
                      : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
