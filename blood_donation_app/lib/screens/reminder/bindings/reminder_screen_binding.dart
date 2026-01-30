
import 'package:blood_donation_app/screens/reminder/controller/reminder_screen_controller.dart';

import '../../../utilities/app_exports.dart';

class ReminderScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReminderScreenController());
  }
}