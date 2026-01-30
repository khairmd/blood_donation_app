import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:blood_donation_app/screens/calendar/view/calendar_screen.dart';
import 'package:blood_donation_app/screens/dashboard/dashboard_view.dart';
import 'package:blood_donation_app/screens/favorite_screen/favorite_screen.dart';
// import 'package:blood_donation_app/screens/journal/controllers/journal_screen_controller.dart';
// import 'package:blood_donation_app/screens/journal/views/journal_screen.dart';
import 'package:blood_donation_app/screens/login/login_binding.dart';
import 'package:blood_donation_app/screens/login/login_view.dart';
import 'package:blood_donation_app/screens/quiz/views/daily_quiz_view.dart';
import 'package:blood_donation_app/screens/settings/views/profile_screen.dart';
import 'package:blood_donation_app/screens/settings/views/settings_screen.dart';
import 'package:blood_donation_app/screens/subscription/view/subscription_screen.dart';
import 'package:blood_donation_app/widgets/custom_dialog.dart';

import '../../utilities/app_exports.dart';
import '../requests/requests_view.dart';
import '../search/search_view.dart';

class HomeController extends GetxController {
  var currentTabIndex = 0.obs;

  final AdvancedDrawerController drawerController = AdvancedDrawerController();

  bool get isLogin => UserPreferences.isLogin;

  static HomeController get find {
    try {
      return Get.find<HomeController>();
    } catch (e) {
      return Get.put(HomeController());
    }
  }

  var pageTitle = <String>[
    "Home", // 0
    "Search", // 1
    "Requests", // 2
    "My Profile", // 3
    "Daily Quiz", // 4
    "Quiz History", //5
    "Journal", // 6
    "Notification", // 7
    "Subscription", // 8
    "Favorites", // 9
    "Settings", // 10
  ];

  var pages = <Widget>[
    DashboardView(),
    SearchView(),
    RequestsView(),
    ProfileScreen(),
    ProfileScreen(),
    DailyQuizView(),
    Center(child: Text("Quiz History")),
    // JournalScreen(),
    Center(child: Text("Notification")),
    SubscriptionScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];

  // RxBool get isJournalCreated => Get.put(JournalScreenController()).isJournalCreated;

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2), () {
      // Get.dialog(BannerDialogWidget());
    });
    super.onInit();
  }

  showLoginDialog() {
    Get.dialog(
      CustomDialog(
        title: "Login to your account.",
        message: "Please sign in to access your personalized settings and features.",
        imageIcon: AppConstants.personIcon,
        btnText: "Login",
        onButtonTap: () {
          Get.offAll(() => LoginView(), binding: LoginBinding());
        },
      ),
    );
  }
}
