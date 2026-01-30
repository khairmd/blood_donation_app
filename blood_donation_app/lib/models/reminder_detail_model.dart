class ReminderDetails {
  ReminderDetails({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    required this.time,
    required this.dayOfMonth,
    required this.month,
    required this.createdAt,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? description;
  final String? type;
  final DateTime? date;
  final String? time;
  final dynamic dayOfMonth;
  final dynamic month;
  final DateTime? createdAt;

  factory ReminderDetails.fromJson(Map<String, dynamic> json) {
    return ReminderDetails(
      id: json["id"],
      userId: json["user_id"],
      title: json["title"],
      description: json["description"],
      type: json["type"],
      date: DateTime.tryParse(json["date"] ?? ""),
      time: json["time"],
      dayOfMonth: json["day_of_month"],
      month: json["month"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "description": description,
    "type": type,
    "date": date?.toIso8601String(),
    "time": time,
    "day_of_month": dayOfMonth,
    "month": month,
    "created_at": createdAt?.toIso8601String(),
  };
}
