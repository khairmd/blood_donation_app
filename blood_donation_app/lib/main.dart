import 'screens/splash.dart';
import 'utilities/app_exports.dart';
import 'utilities/app_initializer.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return Obx(()=>GetMaterialApp(
          title: 'Path To Water',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppGlobals.isDarkMode.value? ThemeMode.dark : ThemeMode.light, // or ThemeMode.light/dark
          home: const SplashScreen(),
          navigatorKey: AppGlobals.appNavigationKey,
        ));
      },
    );
  }
}



