import 'package:blood_donation_app/models/history_model.dart';

class FavoriteHistoryModel {
  FavoriteHistoryModel({
    required this.id,
    required this.userId,
    required this.historyId,
    required this.createdAt,
    required this.history,
  });

  final String? id;
  final String? userId;
  final String? historyId;
  final DateTime? createdAt;
  final HistoryModel? history;

  factory FavoriteHistoryModel.fromJson(Map<String, dynamic> json) {
    return FavoriteHistoryModel(
      id: json["id"],
      userId: json["user_id"],
      historyId: json["history_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      history: json["history"] == null ? null : HistoryModel.fromJson(json["history"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "history_id": historyId,
    "created_at": createdAt?.toIso8601String(),
    "history": history?.toJson(),
  };
}
