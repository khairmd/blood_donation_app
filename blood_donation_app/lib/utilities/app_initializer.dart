import 'app_exports.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import '../notification_services/fcm_controller.dart';
import '../notification_services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    log("FCM Token: $fcmToken");

    await NotificationService().initNotification();
    await listenToFCM();
    await initializePreferences();

    _setOrientationLock();
  }

  static void _setOrientationLock() {
    bool isTablet = Get.context?.isTablet ?? false;
    SystemChrome.setPreferredOrientations(
      isTablet
          ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
          : [DeviceOrientation.portraitUp],
    );
  }
}
