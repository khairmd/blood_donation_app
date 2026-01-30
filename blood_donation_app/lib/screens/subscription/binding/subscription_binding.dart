import 'package:get/get.dart';
import 'package:blood_donation_app/screens/subscription/controller/subscription_controller.dart';

class SubscriptionBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(SubscriptionController());
  }
}