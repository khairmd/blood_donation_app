import 'settings_controller.dart';
import '../../utilities/app_exports.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}