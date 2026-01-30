import 'package:blood_donation_app/models/reminder_detail_model.dart';

class RemindersModel {
  RemindersModel({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<ReminderDetails> data;
  final num? total;
  final num? page;
  final num? limit;

  factory RemindersModel.fromJson(Map<String, dynamic> json) {
    return RemindersModel(
      data:
          json["data"] == null
              ? []
              : List<ReminderDetails>.from(json["data"]!.map((x) => ReminderDetails.fromJson(x))),
      total: json["total"],
      page: json["page"],
      limit: json["limit"],
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
    "total": total,
    "page": page,
    "limit": limit,
  };
}
