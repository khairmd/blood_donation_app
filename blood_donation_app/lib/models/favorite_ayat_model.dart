import 'package:blood_donation_app/models/quran_ayat_model.dart';

class FavoriteAyahModel {
  FavoriteAyahModel({
    required this.id,
    required this.userId,
    required this.ayahId,
    required this.dateFav,
    required this.ayah,
  });

  final String? id;
  final String? userId;
  final String? ayahId;
  final DateTime? dateFav;
  final QuranAyatModel? ayah;

  factory FavoriteAyahModel.fromJson(Map<String, dynamic> json) {
    return FavoriteAyahModel(
      id: json["id"],
      userId: json["user_id"],
      ayahId: json["ayah_id"],
      dateFav: DateTime.tryParse(json["date_fav"] ?? ""),
      ayah: json["ayah"] == null ? null : QuranAyatModel.fromJson(json["ayah"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "ayah_id": ayahId,
    "date_fav": dateFav?.toIso8601String(),
    "ayah": ayah?.toJson(),
  };
}
