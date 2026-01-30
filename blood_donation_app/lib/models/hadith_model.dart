class HadithModel {
  HadithModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.englishTranslation,
    required this.sahihReference,
    required this.explanation,
    required this.isPublished,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.publishDate,
  });

  final String? id;
  final String? title;
  final String? arabicText;
  final String? englishTranslation;
  final String? sahihReference;
  final String? explanation;
  final bool? isPublished;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CreatedBy? createdBy;
  final DateTime? publishDate;

  bool isFavorite = false;

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json["id"],
      title: json["title"],
      arabicText: json["arabic_text"],
      englishTranslation: json["english_translation"],
      sahihReference: json["sahih_reference"],
      explanation: json["explanation"],
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
    "arabic_text": arabicText,
    "english_translation": englishTranslation,
    "sahih_reference": sahihReference,
    "explanation": explanation,
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
