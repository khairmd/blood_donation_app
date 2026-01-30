class HistoryModel {
  HistoryModel({
    required this.id,
    required this.title,
    required this.detail,
    required this.isPublished,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.publishDate,
  });

  final String? id;
  final String? title;
  final String? detail;
  final bool? isPublished;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CreatedBy? createdBy;
  final DateTime? publishDate;

  bool isFavorite = false;

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json["id"],
      title: json["title"],
      detail: json["detail"],
      isPublished: json["is_published"],
      createdById: json["created_by_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      publishDate: DateTime.tryParse(json["publish_date"] ?? ""),
      createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "detail": detail,
    "is_published": isPublished,
    "created_by_id": createdById,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "created_by": createdBy?.toJson(),
  };
}

class CreatedBy {
  CreatedBy({required this.id, required this.name, required this.email});

  final String? id;
  final String? name;
  final String? email;

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(id: json["id"], name: json["name"], email: json["email"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
