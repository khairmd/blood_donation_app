import 'package:blood_donation_app/models/hadith_model.dart';

class FavoriteHadithModel {
  FavoriteHadithModel({
    required this.id,
    required this.userId,
    required this.hadithId,
    required this.createdAt,
    required this.hadith,
  });

  final String? id;
  final String? userId;
  final String? hadithId;
  final DateTime? createdAt;
  final HadithModel? hadith;

  factory FavoriteHadithModel.fromJson(Map<String, dynamic> json) {
    return FavoriteHadithModel(
      id: json["id"],
      userId: json["user_id"],
      hadithId: json["hadith_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      hadith: json["hadith"] == null ? null : HadithModel.fromJson(json["hadith"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "hadith_id": hadithId,
    "created_at": createdAt?.toIso8601String(),
    "hadith": hadith?.toJson(),
  };
}
