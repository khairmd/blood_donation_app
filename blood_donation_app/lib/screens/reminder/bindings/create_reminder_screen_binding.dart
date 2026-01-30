import 'package:blood_donation_app/screens/reminder/controller/create_reminder_screen_controller.dart';

import '../../../utilities/app_exports.dart';

class CreateReminderScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateReminderScreenController());
  }
}
