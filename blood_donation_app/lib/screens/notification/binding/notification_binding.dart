import 'package:get/get.dart';
import 'package:blood_donation_app/screens/notification/controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}
