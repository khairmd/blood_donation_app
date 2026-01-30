import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:blood_donation_app/screens/quiz/quiz_binding.dart';
import 'package:blood_donation_app/screens/quiz/quiz_controller.dart';
import 'package:blood_donation_app/screens/quiz/views/quiz_detail_view.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';

import '../../../models/quiz_history_model.dart';

class DailyQuizHistoryView extends StatelessWidget {
  const DailyQuizHistoryView({super.key});

  QuizController get controller => Get.find<QuizController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Daily Quiz History",
        centerTitle: true,
        showBackIcon: true,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: GetBuilder<QuizController>(
        init: controller,
        builder: (_) {
          return RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: controller.searchController,
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
                    onChanged: controller.onSearch,
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: PagingListener(
                      controller: controller.pagingController,
                      builder: (context, state, fetchNextPage) {
                        return PagedListView.separated(
                          state: state,
                          fetchNextPage: fetchNextPage,
                          builderDelegate: PagedChildBuilderDelegate<
                            QuizHistoryModelData
                          >(
                            animateTransitions: true,
                            itemBuilder: (context, item, index) {
                              return GestureDetector(
                                onTap:
                                    () => Get.to(
                                      () => QuizDetailView(id: item.id ?? ''),
                                      binding: QuizBinding(),
                                    ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppColors.dialogBgColor,
                                    border: Border.all(
                                      color:
                                          AppGlobals.isDarkMode.value
                                              ? AppColors.strokeDarkGreyColor
                                              : AppColors.strokeColor,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(12.r),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreenColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          AppConstants.quizIcon2,
                                        ),
                                      ),
                                      6.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CustomText(
                                                  item.quiz?.title,
                                                  style:
                                                      AppTextTheme.titleMedium,
                                                ),
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    CustomText('${item.score}'),
                                                    SvgPicture.asset(
                                                      AppConstants.star,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            CustomText(
                                              AppGlobals.formatDate(
                                                DateTime.tryParse(
                                                  item.completedAt ?? '',
                                                ),
                                              ),
                                              style: AppTextTheme.bodySmall,
                                            ),
                                            8.verticalSpace,
                                            CustomText(
                                              'Total Question 5',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            CustomText(
                                              'Answer Right ${item.score}',
                                              style: AppTextTheme.bodySmall
                                                  .copyWith(
                                                    color: AppColors.greenColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          separatorBuilder: (context, index) {
                            return 8.verticalSpace;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
