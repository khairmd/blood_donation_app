class JournalsModel {
  JournalsModel({required this.items, required this.meta});

  final List<JournalDetail> items;
  final Meta? meta;

  factory JournalsModel.fromJson(Map<String, dynamic> json) {
    return JournalsModel(
      items:
          json["items"] == null
              ? []
              : List<JournalDetail>.from(json["items"]!.map((x) => JournalDetail.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
    "meta": meta?.toJson(),
  };
}

class JournalDetail {
  JournalDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  final String? id;
  final String? title;
  final String? description;
  final DateTime? date;
  final String? time;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;

  factory JournalDetail.fromJson(Map<String, dynamic> json) {
    return JournalDetail(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      date: DateTime.tryParse(json["date"] ?? ""),
      time: json["time"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date?.toIso8601String(),
    "time": time,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "userId": userId,
  };
}

class Meta {
  Meta({required this.total, required this.page, required this.limit, required this.totalPages});

  final num? total;
  final num? page;
  final num? limit;
  final num? totalPages;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json["total"],
      page: num.tryParse(json["page"].toString()),
      limit: json["limit"],
      totalPages: json["totalPages"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}
