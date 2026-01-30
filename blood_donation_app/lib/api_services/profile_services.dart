import 'package:blood_donation_app/models/profile_model.dart';
import '../api_core/api_client.dart';
import '../utilities/app_url.dart';

class ProfileServices{
  static Future<ProfileModel?> getProfile() async {
    final res = await ApiClient().get(AppUrl.getProfileApi);
    return ProfileModel.fromJson(res.data);
  }
  static Future<ProfileModel?> updateProfile(Map<String, dynamic> data) async {
    final res = await ApiClient().put(AppUrl.updateProfileApi,data: data);
    return ProfileModel.fromJson(res.data);
  }
  static Future<ProfileModel?> uploadProfilePic(Map<String, dynamic> data) async {
    final res = await ApiClient().post(AppUrl.updateProfilePicApi,data: data,isFormData: true,);
    return ProfileModel.fromJson(res.data);
  }
}