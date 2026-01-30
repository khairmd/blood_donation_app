
import 'package:blood_donation_app/screens/favorite_screen/favorite_screen_controller.dart';

import '../../utilities/app_exports.dart';

class FavoriteScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoriteScreenController());
  }
}