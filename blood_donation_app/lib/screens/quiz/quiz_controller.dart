import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:blood_donation_app/screens/quiz/quiz_binding.dart';

import '../../utilities/app_exports.dart';
import '../../models/daily_quiz_model.dart';
import '../../models/quiz_result_model.dart';
import '../../models/submit_quiz_model.dart';
import '../../models/quiz_history_model.dart';
import '../../api_services/quiz_services.dart';
import '../../api_core/custom_exception_handler.dart';
import '../../widgets/custom_quiz_answer_dialog.dart';
import '../../screens/quiz/views/daily_quiz_history_view.dart';

class QuizController extends GetxController {
  int initialValue = 1;

  List<Map<String, dynamic>> answersPayload = [];

  void selectAnswer({required String answer, required String label,required String correctLabel}) {
    selectedOption.value = answer;
    selectedLabel.value = label;
    actualLabel.value = correctLabel;
    update();
  }

  void nextQuestion() {
    currentQuestionIndex++;
    initialValue++;
    selectedOption.value = '';
    currentQuestion = dailyQuizModel?.questions?[currentQuestionIndex];
  }

  // --- Dialog Logic ---

  void showAnswerDialog(BuildContext context) {
    Get.dialog(
      CustomQuizAnswerDialog(
        question: currentQuestion?.text ?? '',
        givenAnswer: selectedOption.value,
        actualAnswer:
            currentQuestion?.options
                ?.firstWhere((e) => e?.isCorrect == true)
                ?.text ??
            '',
         selectedLabel: selectedLabel.value,
        actualLabel: actualLabel.value,
        explanation: currentQuestion?.description ?? '',
        onNextButtonTap: () => handleNextQuestion(context), // Extracted logic
      ),
      barrierDismissible: false,
    );
  }

  void handleNextQuestion(BuildContext context) {
    var totalQuestions = dailyQuizModel?.questions?.length ?? 0;
    Navigator.pop(context); // Close the current dialog
    answersPayload.add({
      'questionId': currentQuestion?.id ?? '',
      'selectedOptionId': selectedOptionId.value,
    });
    if (currentQuestionIndex < totalQuestions - 1) {
      nextQuestion();
    } else {
      submitDailyQuiz(totalQuestions: totalQuestions);
    }
    update(["dailyQuiz"]);
  }

  void showResultDialog({required int totalQuestions, required int score}) {
    Get.dialog(
      CustomResultDialog(
        totalQuestions: totalQuestions,
        correctAnswers: score,
        onViewQuizHistoryButtonTap: () {
          Navigator.pop(Get.context!); // Close result dialog
          Get.off(() => DailyQuizHistoryView(), binding: QuizBinding());
        },
      ),
      barrierDismissible: false,
    );
  }

  int currentQuestionIndex = 0;
  var selectedLabel = ''.obs;
  var actualLabel = ''.obs;
  var selectedOption = ''.obs;
  var selectedOptionId = ''.obs;

  RxBool isLoading = false.obs;
  DailyQuizModel? dailyQuizModel;
  SubmitQuizModel? submitQuizModel;
  QuizResultModel? quizResultModel;
  DailyQuizModelQuestions? currentQuestion;

  final RxInt _selectedQuestion = 0.obs;

  int get selectedQuestion => _selectedQuestion.value;

  void setSelectedQuestion(int index) {
    _selectedQuestion.value = index;
  }

  int currentPage = 0;
  bool isLastPage = false;
  late PagingController<int, QuizHistoryModelData> pagingController;
  bool showLoader = true;
  Timer? debounce;
  final TextEditingController searchController = TextEditingController();

  Future getDailyQuiz() async {
    try {
      isLoading(true);
      dailyQuizModel = await QuizServices.getDailyQuiz();
      currentQuestion = dailyQuizModel?.questions?[currentQuestionIndex];
      update(["dailyQuiz"]);
    } on Exception catch (e) {
      isLoading(false);
      ExceptionHandler().handleException(e);
    } finally {
      isLoading(false);
      update(["dailyQuiz"]);
    }
  }

  Future submitDailyQuiz({required int totalQuestions}) async {
    try {
      isLoading(true);
      submitQuizModel = await QuizServices.submitQuiz(
        quizId: dailyQuizModel?.id ?? '',
        data: {"answers": answersPayload},
      );
      showResultDialog(
        totalQuestions: totalQuestions,
        score: submitQuizModel?.score ?? 0,
      );
    } on Exception catch (e) {
      isLoading(false);
      ExceptionHandler().handleException(e);
    } finally {
      isLoading(false);
    }
  }

  Future<List<QuizHistoryModelData>> getQuizHistory([int? pageNo]) async {
    try {
      final res = await QuizServices.getQuizHistory({
        if (pageNo != null) "page": pageNo,
        if (searchController.text.isNotEmpty) "search": searchController.text,
      });
      isLastPage = (res.data?.length ?? 0) < (res.limit ?? 0);
      currentPage++;
      return res.data ?? [];
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    }
    return [];
  }

  Future getQuizResult({required String id}) async {
    try {
      isLoading(true);
      quizResultModel = await QuizServices.getQuizResult(id: id);
      setSelectedQuestion(1);
      update(["quizResult"]);
    } on Exception catch (e) {
      isLoading(false);
      ExceptionHandler().handleException(e);
    } finally {
      isLoading(false);
      update(["quizResult"]);
    }
  }

  void onRefresh() {
    pagingController.refresh();
    currentPage = 0;
    isLastPage = false;
    pagingController.fetchNextPage();
  }

  onSearch(String? value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      onRefresh();
    });
  }

  @override
  void onInit() {
    super.onInit();
    pagingController = PagingController(
      getNextPageKey: (state) => isLastPage ? null : currentPage + 1,
      fetchPage: (int pageKey) => getQuizHistory(pageKey),
    );
    WidgetsBinding.instance.addPostFrameCallback((d) {
      pagingController.fetchNextPage();
    });
  }
}
