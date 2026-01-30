import 'package:blood_donation_app/models/hadith_model.dart';
import 'package:blood_donation_app/models/history_model.dart';
import 'package:blood_donation_app/models/quran_ayat_model.dart';

class DailyContent {
  DailyContent({required this.hadiths, required this.ayahs, required this.histories});

  final List<HadithModel> hadiths;
  final List<QuranAyatModel> ayahs;
  final List<HistoryModel> histories;

  factory DailyContent.fromJson(Map<String, dynamic> json) {
    return DailyContent(
      hadiths:
          json["hadiths"] == null
              ? []
              : List<HadithModel>.from(json["hadiths"]!.map((x) => HadithModel.fromJson(x))),
      ayahs:
          json["ayahs"] == null
              ? []
              : List<QuranAyatModel>.from(json["ayahs"]!.map((x) => QuranAyatModel.fromJson(x))),
      histories:
          json["histories"] == null
              ? []
              : List<HistoryModel>.from(json["histories"]!.map((x) => HistoryModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "hadiths": hadiths.map((x) => x.toJson()).toList(),
    "ayahs": ayahs.map((x) => x.toJson()).toList(),
    "histories": histories.map((x) => x.toJson()).toList(),
  };
}
