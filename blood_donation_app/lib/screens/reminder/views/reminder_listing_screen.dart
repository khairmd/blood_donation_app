import 'package:hijri/hijri_calendar.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:blood_donation_app/models/reminder_detail_model.dart';
import 'package:blood_donation_app/screens/reminder/bindings/create_reminder_screen_binding.dart';
import 'package:blood_donation_app/screens/reminder/controller/reminder_listing_controller.dart';
import 'package:blood_donation_app/screens/reminder/controller/reminder_screen_controller.dart';
import 'package:blood_donation_app/screens/reminder/views/create_reminder_screen.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import 'package:blood_donation_app/widgets/custom_calendar.dart';
import 'package:blood_donation_app/widgets/custom_dialog.dart';
import 'package:blood_donation_app/widgets/custom_quran_info_dialog.dart';
import 'package:blood_donation_app/widgets/custom_tab_widget.dart';

class ReminderListingScreen extends StatelessWidget {
  ReminderListingScreen({super.key});

  ReminderListingController get controller => Get.put(ReminderListingController());

  final InfiniteScrollController scrollController = InfiniteScrollController();

  final ReminderScreenController reminderScreenController = Get.put<ReminderScreenController>(
    ReminderScreenController(),
  );
  final double _itemExtent = 70.w;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.scrollToSelectedDate(scrollController);
        });
      },
      builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            reminderScreenController.onRefresh();
          },
          child: Column(
            children: [
              10.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppGlobals.isDarkMode.value ? AppColors.dark : AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          controller.isEnglishCalendar
                              ? controller.focusedMonth.toFormatDateTime(format: "MMMM, yyyy")
                              : controller.focusedHijriMonthText,
                        ),
                        8.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            showDualCalendar(
                              context,
                              initialDate: controller.selectedDate,
                              selectedDate: controller.selectedDate,
                              onDateSelected: (date) {
                                controller.onDateSelected(date);
                                controller.generateVisibleDates(date);
                                controller.scrollToSelectedDate(scrollController);
                                reminderScreenController.onRefresh(date);
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(3.r),
                              color: Colors.transparent,
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.primary,
                              size: 12.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    SizedBox(
                      height: 70.h,
                      child: InfiniteCarousel.builder(
                        itemCount: controller.visibleDates.length,
                        itemExtent: _itemExtent,
                        center: true,
                        loop: false,
                        anchor: 0.0,
                        velocityFactor: 0.2,
                        onIndexChanged: (index) {},
                        controller: scrollController,
                        axisDirection: Axis.horizontal,
                        itemBuilder: (context, index, realIndex) {
                          final currentOffset = _itemExtent * realIndex;
                          final date = controller.visibleDates[index];
                          return AnimatedBuilder(
                            animation: scrollController,
                            builder: (context, child) {
                              if (scrollController.hasClients) {
                                final diff = (scrollController.offset - currentOffset);
                                const maxPadding = 4.0;
                                final carouselRatio = _itemExtent / maxPadding;

                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: (diff / carouselRatio).abs(),
                                    bottom: (diff / carouselRatio).abs(),
                                  ),
                                  child: child,
                                );
                              }
                              return child!;
                            },
                            child: _buildDateItem(date, controller),
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,
                    GetBuilder(
                      init: controller,
                      builder: (c_) {
                        return Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: DefaultTabController(
                              length: 2,
                              initialIndex: controller.isEnglishCalendar ? 0 : 1,
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                labelPadding: EdgeInsets.zero,
                                tabs: [
                                  CustomTab(
                                    title: "English Calendar",
                                    isSelected: controller.isEnglishCalendar,
                                  ),
                                  CustomTab(
                                    title: "Arabic Calendar",
                                    isSelected: controller.isEnglishCalendar == false,
                                  ),
                                ],
                                isScrollable: false,
                                indicator: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                onTap: (value) {
                                  controller.isEnglishCalendar = value == 0;
                                  controller.update();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextFormField(
                  controller: reminderScreenController.searchController,
                  upperLabel: "",
                  upperLabelReqStar: "",
                  hintValue: "Search",
                  borderColor: AppColors.primary,
                  outerPadding: EdgeInsets.zero,
                  prefixIcon: CustomImageView(
                    imagePath: AppConstants.searchIcon,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                  onChanged: reminderScreenController.onSearch,
                ),
              ),
              12.verticalSpace,
              Expanded(
                child: PagingListener(
                  controller: reminderScreenController.pagingController,
                  builder: (context, state, fetchNextPage) {
                    return PagedListView.separated(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      builderDelegate: PagedChildBuilderDelegate<ReminderDetails>(
                        animateTransitions: true,
                        itemBuilder:
                            (context, item, index) => _buildEntryItem(
                              item,
                              index == (state.items?.length ?? 0) - 1,
                              context,
                              index,
                              (state.items?.length ?? 0) > 1,
                            ),
                      ),
                      
                      separatorBuilder: (context, index) => SizedBox.shrink(),
                    );
                  },
                ),
                // DummyContent.allEntries.isEmpty
                //     ? Center(
                //       child: Text(
                //         'No entries for this date.',
                //         style: TextStyle(color: Colors.grey[600]),
                //       ),
                //     )
                //     : _buildEntriesList(DummyContent.allEntries, context),
              ),
              // Expanded(
              //   child:
              //       DummyContent.allEntries.isEmpty
              //           ? Center(
              //             child: Text(
              //               'No entries for this date.',
              //               style: TextStyle(color: Colors.grey[600]),
              //             ),
              //           )
              //           : _buildEntriesList(DummyContent.allEntries, context),
              // ),
              120.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateItem(DateTime date, ReminderListingController controller) {
    final bool isSelected =
        date.year == controller.selectedDate.year &&
        date.month == controller.selectedDate.month &&
        date.day == controller.selectedDate.day;

    String dayNumber;
    String dayName;

    if (controller.isEnglishCalendar) {
      dayNumber = DateFormat('d').format(date);
      dayName = DateFormat('E').format(date); // Short day name (Sun, Mon)
    } else {
      HijriCalendar hijri = HijriCalendar.fromDate(date);
      // HijriCalendar.setLocal('ar'); // For Arabic day names/numbers
      dayNumber = hijri.hDay.toString();
      dayName = hijri.getDayName().substring(0, 3);
    }

    return GestureDetector(
      onTap: () {
        controller.onDateSelected(date);
        reminderScreenController.onRefresh(date);
      },
      child: Container(
        width: 60.w, // Fixed width for each date item
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.dialogBgColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: AppColors.primary.withAlpha(100)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: CustomText(
                dayName,
                color: isSelected ? AppColors.lightColor : AppColors.grey500,
              ),
            ),
            6.verticalSpace,
            FittedBox(
              child: CustomText(
                dayNumber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildEntriesList(List<CalendarEntry> list, BuildContext context) {
  //   return ListView.builder(
  //     padding: EdgeInsets.symmetric(horizontal: 16.0),
  //     itemCount: list.length,
  //     itemBuilder: (context, index) {
  //       final entry = list[index];
  //       bool isLast = index == list.length - 1;
  //       return _buildEntryItem(entry, isLast, context);
  //     },
  //   );
  // }

  Widget _buildEntryItem(
    ReminderDetails entry,
    bool isLast,
    BuildContext context,
    int index,
    bool showLine,
  ) {
    final timeFormatted = entry.time; // e.g., 10:30 PM

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: showLine ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (showLine && index == 0)
                8.verticalSpace
              else if (showLine && index != 0)
                Container(
                  width: 1, // Line thickness
                  height: 8,
                  color: AppColors.primary, // Spacing around line
                ),
              Container(
                width: 60.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: CustomText(timeFormatted, color: Colors.white, fontSize: 11),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 1, // Line thickness
                    margin: isLast ? EdgeInsets.only(bottom: 16.h) : null,
                    color: AppColors.primary, // Spacing around line
                  ),
                )
              else
                12.verticalSpace,
            ],
          ),
          22.horizontalSpace,
          // Content Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                showQuranInfoDialog(
                  context,
                  quranDialogTitle: "Reminder",
                  contentTitle: entry.title,
                  englishContent: entry.description,
                  showLanguageSelectionButton: false,
                  date: entry.date,
                );
              },
              child: Card(
                elevation: 0,
                margin: EdgeInsets.only(bottom: 16, top: 2), // Card margin
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColors.strokeColor),
                ),
                color: AppColors.dialogBgColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: CustomText(entry.title, fontWeight: FontWeight.w500)),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: AppColors.primary),
                            onSelected: (value) {},
                            color:
                                AppGlobals.isDarkMode.value ? AppColors.grey700 : AppColors.grey100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              side: BorderSide(color: AppColors.greenStrokeColor),
                            ),
                            itemBuilder:
                                (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    height: 30.h,
                                    value: 'edit',
                                    onTap: () {
                                      Get.to(
                                        () => CreateReminderScreen(reminderDetails: entry),
                                        binding: CreateReminderScreenBinding(),
                                      )?.then((value) {
                                        if (value == true) {
                                          reminderScreenController.onRefresh();
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        CustomImageView(
                                          svgPath: AppConstants.editSvgIcon,
                                          height: 14.h,
                                          color: AppColors.surface,
                                        ),
                                        SizedBox(width: 8),
                                        CustomText('Edit', fontSize: 12),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    height: 30.h,
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        CustomImageView(
                                          svgPath: AppConstants.trashSvgIcon,
                                          height: 14.h,
                                          color: Colors.redAccent,
                                        ),
                                        SizedBox(width: 8),
                                        CustomText('Delete', fontSize: 12),
                                      ],
                                    ),
                                    onTap: () {
                                      Get.dialog(
                                        CustomDialog(
                                          message: "Are you sure you want to delete this reminder?",
                                          imageIcon: AppConstants.trashIcon,
                                          title: "Delete Reminder",
                                          btnText: "Delete",
                                          onButtonTap: () {
                                            reminderScreenController.deleteReminderApi(
                                              entry.id ?? "",
                                            );
                                            Get.back();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                          ),
                        ],
                      ),
                      CustomText(entry.description, fontSize: 14, maxLine: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
