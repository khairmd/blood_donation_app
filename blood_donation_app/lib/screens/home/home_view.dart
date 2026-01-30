import 'package:blood_donation_app/screens/home/home_controller.dart';
import 'package:blood_donation_app/widgets/custom_advanced_drawer.dart';

import '../../utilities/app_exports.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  HomeController get controller => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CustomAdvancedDrawer(
      controller: controller.drawerController,
      homeController: controller,
      child: GetX(
        init: controller,
        builder: (_) {
          return Scaffold(
            appBar: CustomAppBar(
              text: controller.pageTitle[controller.currentTabIndex.value],
              showMenuIcon: true,
              centerTitle: true,
              bgColor: Colors.transparent,
              onMenuPressed: () {
                if (!controller.isLogin) {
                  controller.showLoginDialog();
                  return;
                }
                controller.drawerController.showDrawer();
              },
            ),
            extendBodyBehindAppBar: controller.currentTabIndex.value == 0,
            extendBody: [0, 1, 6, 8].contains(controller.currentTabIndex.value),
            backgroundColor: AppColors.scaffoldBackground,
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: controller.pages[controller.currentTabIndex.value],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: AppColors.primary,
                ),
                child: SafeArea(
                  // height: 75.h,
                  // clipBehavior: Clip.antiAlias,
                  // shape: CircularNotchedRectangle(),
                  // color: AppColors.primary,
                  // surfaceTintColor: AppColors.primary,
                  child: Obx(() {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.currentTabIndex.value = 0;
                            },
                            child: buildSvgIconWidget(
                              assetName: AppConstants.homeIcon,
                              label: "Home",
                              isSelected: controller.currentTabIndex.value == 0,
                            ),
                          ),
                        ),
                        4.horizontalSpace,
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!controller.isLogin) {
                                controller.showLoginDialog();
                                return;
                              }
                              controller.currentTabIndex.value = 1;
                            },
                            child: buildSvgIconWidget(
                              assetName: AppConstants.clockIcon,
                              label: "Search",
                              isSelected: controller.currentTabIndex.value == 1,
                            ),
                          ),
                        ),
                        4.horizontalSpace,

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!controller.isLogin) {
                                controller.showLoginDialog();
                                return;
                              }
                              controller.currentTabIndex.value = 2;
                            },
                            child: buildSvgIconWidget(
                              assetName: AppConstants.calendarIcon,
                              label: "Requests",
                              isSelected: controller.currentTabIndex.value == 2,
                            ),
                          ),
                        ),
                        4.horizontalSpace,

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!controller.isLogin) {
                                controller.showLoginDialog();
                                return;
                              }
                              controller.currentTabIndex.value = 3;
                            },
                            child: buildSvgIconWidget(
                              assetName: AppConstants.profileIcon,

                              label: "Profile",
                              isSelected: controller.currentTabIndex.value == 3,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            floatingActionButton: Visibility(
              // visible:
              //     [1, 2].contains(controller.currentTabIndex.value) ||
              //     (controller.currentTabIndex.value == 6 && controller.isJournalCreated.value),
              child: FloatingActionButton(
                onPressed: (){},
                shape: CircleBorder(),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSvgIconWidget({
    required String assetName,
    required String label,
    bool isSelected = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          label == 'Search'
              ? Icon(Icons.search)
              : label == 'Requests'
              ? Icon(Icons.request_page_outlined)
              : CustomImageView(
                imagePath: assetName,
                height: 22,
                width: 22,
                color: isSelected ? AppColors.primary : AppColors.lightColor,
              ),
          4.verticalSpace,
          CustomText(
            label,
            color: isSelected ? AppColors.primary : AppColors.lightColor,
          ),
        ],
      ),
    );
  }
}
