import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:blood_donation_app/api_core/custom_exception_handler.dart';
import 'package:blood_donation_app/api_services/reminder_service.dart';
import 'package:blood_donation_app/models/reminder_detail_model.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class ReminderScreenController extends GetxController {
  int currentPage = 0;
  bool isLastPage = false;
  late PagingController<int, ReminderDetails> pagingController;
  RxBool isReminderCreated = false.obs;
  bool showLoader = true;
  DateTime dateTime = DateTime.now();
  Timer? debounce;
  final TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    checkReminderCreated();
    pagingController = PagingController(
      getNextPageKey: (state) => isLastPage ? null : currentPage + 1,
      fetchPage: (int pageKey) => getReminderApi(pageKey),
    );
    pagingController.fetchNextPage();
  }

  Future<List<ReminderDetails>> getReminderApi([int? pageNo]) async {
    try {
      if (showLoader) {
        AppGlobals.isLoading(true);
        showLoader = false;
      }
      final res = await ReminderService.getAllReminder({
        if (pageNo != null) "page": pageNo,
        "startDate": dateTime.toFormatDateTime(format: "yyyy-MM-dd"),
        "endDate": dateTime.toFormatDateTime(format: "yyyy-MM-dd"),
        if (searchController.text.isNotEmpty) "search": searchController.text,
      });
      isLastPage = (res?.data.length ?? 0) < (res?.limit ?? 0);
      currentPage++;

      return res?.data ?? [];
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
    return [];
  }

  Future<void> checkReminderCreated() async {
    try {
      final res = await ReminderService.getAllReminder({"page": 1});
      isReminderCreated.value = res?.data.isNotEmpty ?? false;
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future deleteReminderApi(String reminderId) async {
    try {
      await ReminderService.deleteReminder(reminderId);
      onRefresh();
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    }
  }

  void onRefresh([DateTime? date]) {
    if (date != null) dateTime = date;
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
}
