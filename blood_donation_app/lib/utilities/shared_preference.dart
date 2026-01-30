import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

initializePreferences() async {
  prefs = await SharedPreferences.getInstance();
}

class UserPreferences {

  static set currentServer(String currentServer) {prefs.setString('currentServer', currentServer);}
  static String get currentServer => prefs.getString('currentServer') ?? "Live";

  static set apiURL(String apiURL) {prefs.setString('apiURL', apiURL);}
  static String get apiURL => prefs.getString('apiURL') ?? "";

  static set socketURL(String socketURL) {prefs.setString('socketURL', socketURL);}
  static String get socketURL => prefs.getString('socketURL') ?? "";

  static set webURL(String webURL) {prefs.setString('webURL', webURL);}
  static String get webURL => prefs.getString('webURL') ?? "";

  static set mediaURL(String mediaURL) {prefs.setString('mediaURL', mediaURL);}
  static String get mediaURL => prefs.getString('mediaURL') ?? "";

  static set authToken(String authToken) {prefs.setString('authToken', authToken);}
  static String get authToken => prefs.getString('authToken') ?? "";

  static set userId(String id) {prefs.setString('userId', id);}
  static String get userId => prefs.getString('userId') ?? "";

  static set isLogin(bool isLogin) {prefs.setBool('isLogin', isLogin);}
  static bool get isLogin => prefs.getBool('isLogin') ?? false;

  static set loginData(Map<String, dynamic> value) {prefs.setString('loginData', jsonEncode(value));}
  static Map<String, dynamic> get loginData => jsonDecode(prefs.getString('loginData') ?? "{}");

  // Function Example Syntax To Use

  static set saveMap(Map<String, dynamic> value) {prefs.setString('saveMap', jsonEncode(value));}
  static Map<String, dynamic> get saveMap => jsonDecode(prefs.getString('saveMap') ?? "{}");

  static set saveList(List<dynamic> value) {prefs.setString('saveList', jsonEncode(value));}
  static List<dynamic> get saveList => jsonDecode(prefs.getString('saveList') ?? "{}");

  static set saveString(String saveString) {prefs.setString('saveString', saveString);}
  static String get saveString => prefs.getString('saveString') ?? "";

  static set saveInt(int saveInt) {prefs.setInt('saveInt', saveInt);}
  static int get saveInt => prefs.getInt('saveInt') ?? 0;

  static set saveDouble(double saveDouble) {prefs.setDouble('saveDouble', saveDouble);}
  static double get saveDouble => prefs.getDouble('saveDouble') ?? 0.0;

  static removeUserData () {
    prefs.remove('authToken');
    prefs.remove('isLogin');
    prefs.remove('loginData');
  }
}
