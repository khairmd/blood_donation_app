import 'package:hijri/hijri_calendar.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

// To launch the calendar
void showDualCalendar(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? selectedDate,
  Function(DateTime)? onDateSelected,
}) {
  showDialog(
    context: context,
    builder: (builderContext) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16),
        child: DualCalendarView(
          initialDisplayMonth: initialDate ?? DateTime.now(),
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
        ),
      );
    },
  );
}

class DualCalendarView extends StatefulWidget {
  final DateTime initialDisplayMonth;
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;

  const DualCalendarView({
    super.key,
    required this.initialDisplayMonth,
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  _DualCalendarViewState createState() => _DualCalendarViewState();
}

class _DualCalendarViewState extends State<DualCalendarView> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  final DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Custom day abbreviations as per the image
  final List<String> _dayAbbreviations = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final Color _darkBgColor = AppColors.scaffoldBackground; // Slightly lighter than pure black
  final Color _greenAccentColor = AppColors.primary;
  final Color _headerTextColor = AppColors.textPrimary;
  final Color _dayNumberColor = AppColors.textPrimary;
  final Color _otherMonthDayNumberColor = AppColors.grey500;
  final Color _dayHeaderColor = AppColors.textPrimary;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.initialDisplayMonth.year,
      widget.initialDisplayMonth.month,
      1,
    );
    _selectedDate = widget.selectedDate;
    HijriCalendar.setLocal('en'); // For English Hijri month names
  }

  String _getHijriMonthYearString(DateTime gregorianMonth) {
    final firstDayGregorian = DateTime(gregorianMonth.year, gregorianMonth.month, 1);
    final lastDayGregorian = DateTime(gregorianMonth.year, gregorianMonth.month + 1, 0);

    final hijriStartDate = HijriCalendar.fromDate(firstDayGregorian);
    final hijriEndDate = HijriCalendar.fromDate(lastDayGregorian);

    String startHijriName = hijriStartDate.getLongMonthName();
    String endHijriName = hijriEndDate.getLongMonthName();
    String startHijriYear = hijriStartDate.hYear.toString();
    String endHijriYear = hijriEndDate.hYear.toString();

    if (startHijriName == endHijriName && startHijriYear == endHijriYear) {
      return "$startHijriName $startHijriYear";
    } else if (startHijriYear == endHijriYear) {
      return "$startHijriName – $endHijriName $startHijriYear";
    } else {
      // Spans across Hijri years
      return "$startHijriName $startHijriYear – $endHijriName $endHijriYear";
    }
  }

  Future<void> _nextMonth() async {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  Future<void> _previousMonth() async {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _darkBgColor, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildDayOfWeekHeaders(),
          _buildCalendarGrid(),
          const SizedBox(height: 16),
          _buildFooter(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_displayedMonth),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _headerTextColor,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.5,
                    child: Text(
                      _getHijriMonthYearString(_displayedMonth),
                      style: TextStyle(fontSize: 14, color: _headerTextColor.withAlpha(200)),
                    ),
                  ),

                  Spacer(),
                  InkWell(
                    onTap: () => _previousMonth(),
                    child: Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 16.h),
                  ),
                  24.horizontalSpace,
                  InkWell(
                    onTap: () => _nextMonth(),
                    child: Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16.h),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayOfWeekHeaders() {
    return Row(
      children:
          _dayAbbreviations.map((dayAbbr) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.strokeColor, width: 0.2),
                ),
                child: Text(
                  dayAbbr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _dayHeaderColor,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    List<DateTime> days = [];
    DateTime firstDayOfGrid = _displayedMonth.subtract(Duration(days: _displayedMonth.weekday - 1));

    int length = 35;
    if (_displayedMonth.weekday > 5) {
      length = 42;
    }

    for (int i = 0; i < length; i++) {
      // 6 weeks
      days.add(firstDayOfGrid.add(Duration(days: i)));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.7, // Adjust for cell height
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        DateTime date = days[index];
        bool isCurrentMonth = date.month == _displayedMonth.month;
        bool isToday =
            date.year == _today.year && date.month == _today.month && date.day == _today.day;
        bool isSelected =
            _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;

        return _buildDayCell(date, isCurrentMonth, isToday, isSelected);
      },
    );
  }

  Widget _buildDayCell(DateTime date, bool isCurrentMonth, bool isToday, bool isSelected) {
    HijriCalendar hijriDate = HijriCalendar.fromDate(date);

    BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: AppColors.strokeColor, width: 0.2),
      color: isSelected ? AppColors.primary : Colors.transparent,
    );

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.r),
              child: Container(
                padding: isToday ? const EdgeInsets.all(6) : null,
                decoration:
                    isToday
                        ? BoxDecoration(shape: BoxShape.circle, color: AppColors.surface)
                        : null,
                child: CustomText(
                  date.day.toString(),
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color:
                      isToday
                          ? AppColors.scaffoldBackground
                          : isSelected
                          ? AppColors.lightColor
                          : (isCurrentMonth ? _dayNumberColor : _otherMonthDayNumberColor),
                ),
              ),
            ),
            if (isCurrentMonth)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.r),

                    child: CustomText(
                      '(${hijriDate.hDay})',

                      fontSize: 11,
                      color:
                          isSelected
                              ? AppColors.lightColor
                              : (isCurrentMonth
                                  ? _greenAccentColor
                                  : _greenAccentColor.withAlpha(150)),
                    ),
                  ),
                ],
              ),
            // Text(
            //   date.day.toString(),
            //   style: TextStyle(
            //     fontSize: 15,
            //     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            //     color:
            //         isSelected
            //             ? AppColors.lightColor
            //             : (isCurrentMonth ? _dayNumberColor : _otherMonthDayNumberColor),
            //   ),
            // ),
            // if (isCurrentMonth) ...[
            //   8.verticalSpace,
            //   CustomText(
            //     '(${hijriDate.hDay})',

            //     fontSize: 10,
            //     color: isSelected ? AppColors.lightColor : _greenAccentColor,
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: CustomText(
            "Cancel",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        20.horizontalSpace,
        InkWell(
          onTap: () {
            widget.onDateSelected?.call(_selectedDate ?? DateTime.now());
            Navigator.pop(context);
          },
          child: CustomText(
            "Ok",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
