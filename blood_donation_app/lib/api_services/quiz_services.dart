import '../models/quiz_history_model.dart';
import '../models/submit_quiz_model.dart';

import '../models/quiz_result_model.dart';
import '../utilities/app_url.dart';
import '../api_core/api_client.dart';
import '../models/daily_quiz_model.dart';

class QuizServices {
  static Future<DailyQuizModel> getDailyQuiz() async {
    final res = await ApiClient().get(AppUrl.getDailyQuizApi);
    if (res.data is List) {
      return DailyQuizModel.fromJson(res.data[0]);
    } else {
      return DailyQuizModel.fromJson(res.data);
    }
  }

  static Future<SubmitQuizModel> submitQuiz({
    required String quizId,
    required Map<String, dynamic> data,
  }) async {
    final res = await ApiClient().post(
      '${AppUrl.submitQuizApi}/$quizId/submit',
      data: data,
    );
    return SubmitQuizModel.fromJson(res.data);
  }

  static Future<QuizHistoryModel> getQuizHistory(
    Map<String, dynamic> queryParameters,
  ) async {
    final res = await ApiClient().get(
      AppUrl.getQuizHistoryApi,
      queryParameters: queryParameters,
    );
    return QuizHistoryModel.fromJson(res.data);
  }

  static Future<QuizResultModel> getQuizResult({required String id}) async {
    final res = await ApiClient().get('${AppUrl.getQuizResultApi}/$id');
    return QuizResultModel.fromJson(res.data);
  }
}
