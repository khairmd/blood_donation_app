import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:blood_donation_app/api_services/settings_services.dart';
import 'package:blood_donation_app/utilities/app_exports.dart';
import '../../api_core/custom_exception_handler.dart';
import '../../api_services/profile_services.dart';
import '../../widgets/custom_dialog.dart';
import '../splash.dart';

class SettingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController fullNameTFController = TextEditingController();
  final TextEditingController userNameTFController = TextEditingController();
  final TextEditingController emailTFController = TextEditingController();
  final TextEditingController dOBTFController = TextEditingController();
  final TextEditingController genderTFController = TextEditingController();
  final TextEditingController currentPassTFController = TextEditingController();
  final TextEditingController newPassTFController = TextEditingController();
  final TextEditingController confirmNewTFController = TextEditingController();

  RxBool isNotification = false.obs;

  // Function to pick an image
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  final profileImgKey = ''.obs;
  final profilePicture = ''.obs;

  Future uploadImage(Map<String, dynamic> reqBody) async {
    var data = reqBody;
    if (data["file"] != null) {
      data["file"] = await dio.MultipartFile.fromFile(
        data["file"],
        contentType: dio.DioMediaType("image", "jpeg"),
      );
    }
    try {
      AppGlobals.isLoading(true);
      final res = await ProfileServices.uploadProfilePic(data);
      if (res != null) {
        log(res.toString());
        profilePicture.value = res.logo ?? '';
        fullNameTFController.text = res.name ?? '';
        userNameTFController.text = res.userName ?? '';
        emailTFController.text = res.email ?? '';
        dOBTFController.text =
            AppGlobals.formatDate(DateTime.tryParse(res.dob ?? '')) ?? "";
        genderTFController.text = res.gender?.toTitleCase() ?? 'Choose One';
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      log('picked file:${imageFile?.path}');
      update();
      await uploadImage({'file': imageFile?.path});
    }
  }

  Future<void> pickDate() async {
    var date = await AppGlobals().selectDate(Get.context!);
    dOBTFController.text = AppGlobals.formatDate(date) ?? "";
  }

  Future getProfile() async {
    try {
      AppGlobals.isLoading(true);
      final res = await ProfileServices.getProfile();
      if (res != null) {
        profilePicture.value = res.logo ?? '';
        fullNameTFController.text = res.name ?? '';
        userNameTFController.text = res.userName ?? '';
        emailTFController.text = res.email ?? '';
        dOBTFController.text =
            AppGlobals.formatDate(DateTime.tryParse(res.dob ?? '')) ?? "";
        genderTFController.text = res.gender?.toTitleCase() ?? 'Choose One';
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future updateProfile() async {
    try {
      AppGlobals.isLoading(true);
      final res = await ProfileServices.updateProfile({
        "name": fullNameTFController.text,
        "gender":
            genderTFController.text == 'Choose One'
                ? null
                : genderTFController.text.toUpperCase(),
        "dob": AppGlobals.toISOFormatDate(dOBTFController.text),
        "logo": profilePicture.value,
      });
      if (res != null) {
        profilePicture.value = res.logo ?? '';
        fullNameTFController.text = res.name ?? '';
        userNameTFController.text = res.userName ?? '';
        emailTFController.text = res.email ?? '';
        dOBTFController.text =
            AppGlobals.formatDate(DateTime.tryParse(res.dob ?? '')) ?? "";
        genderTFController.text = res.gender?.toTitleCase() ?? 'Choose One';
        Get.dialog(
          CustomDialog(
            title: "Profile Saved",
            message: "Your changes have been saved successfully.",
            imageIcon: AppConstants.celebrationIcon,
            showCloseIcon: false,
            btnText: "Close",
            onButtonTap: () {
              Get.close(2);
            },
          ),
        );
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future changePassword() async {
    try {
      AppGlobals.isLoading(true);
      final res = await SettingsServices.changePassword({
        "currentPassword": currentPassTFController.text,
        "newPassword": newPassTFController.text,
      });
      if (res != null) {
        Get.dialog(
          CustomDialog(
            title: res.message ?? "Password changed successfully",
            message: "",
            imageIcon: AppConstants.celebrationIcon,
            showCloseIcon: false,
            btnText: "Close",
            onButtonTap: () {
              Get.close(2);
            },
          ),
        );
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  Future deleteAccount(String password) async {
    try {
      AppGlobals.isLoading(true);
      currentPassTFController.clear();
      final res = await SettingsServices.deleteAccount({"password": password});
      currentPassTFController.clear();
      log('res::${res?.message}');
      if (res != null) {
        Get.dialog(
          CustomDialog(
            title: res.message ?? "Account deleted successfully",
            message: "",
            imageIcon: AppConstants.trashIcon,
            showCloseIcon: false,
            btnText: "Close",
            onButtonTap: () {
              UserPreferences.loginData = {};
              UserPreferences.isLogin = false;
              UserPreferences.authToken = "";
              UserPreferences.userId = "";
              Get.offAll(() => SplashScreen());
            },
          ),
        );
      }
    } on Exception catch (e) {
      ExceptionHandler().handleException(e);
    } catch (e) {
      log(e.toString());
    } finally {
      AppGlobals.isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      getProfile();
    });
  }
}
