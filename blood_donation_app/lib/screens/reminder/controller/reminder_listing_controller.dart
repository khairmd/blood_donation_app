import 'package:hijri/hijri_calendar.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

class ReminderListingController extends GetxController {
  DateTime focusedMonth = DateTime.now(); // For month/year display
  DateTime selectedDate = DateTime.now(); // For month/year display
  String get focusedHijriMonthText =>
      "${HijriCalendar.fromDate(focusedMonth).getLongMonthName()}, ${HijriCalendar.fromDate(focusedMonth).hYear}";

  bool isEnglishCalendar = true;
  List<DateTime> visibleDates = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    focusedMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    generateVisibleDates(selectedDate);
  }


  void onDateSelected(DateTime date) {
    selectedDate = date;
    if (selectedDate.month != focusedMonth.month || selectedDate.year != focusedMonth.year) {
      focusedMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    }

    update();
  }

  void generateVisibleDates(DateTime centerDate) {
    visibleDates.clear();
    // Show 3 days before, centerDate, and 3 days after (total 7 days)
    // Adjust this range as needed
    for (int i = 1; i < DateTime(centerDate.year, centerDate.month, 0).day; i++) {
      // Show a wider range for better scrolling
      visibleDates.add(DateTime(centerDate.year, centerDate.month, i));
    }
  }

  void scrollToSelectedDate(InfiniteScrollController scrollController) {
    // Scroll to selected date after layout
    // _scrollToSelectedDate(animate: false);
    if (scrollController.hasClients) {
      int selectedIndex = visibleDates.indexOf(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      );
      if (selectedIndex != -1) {
        scrollController.animateToItem(
          selectedIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
