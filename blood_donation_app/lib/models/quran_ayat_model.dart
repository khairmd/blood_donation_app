class QuranAyatModel {
  QuranAyatModel({
    required this.id,
    required this.surahName,
    required this.surahNameArabic,
    required this.ayahNumber,
    required this.textArabic,
    required this.textRoman,
    required this.textEnglish,
    required this.detailEnglishPopup,
    required this.detailArabicPopup,
    required this.dateAdded,
    required this.addedById,
    required this.isPublished,
    required this.publishDate,
    this.isFavorite = false,
  });

  final String? id;
  final String? surahName;
  final String? surahNameArabic;
  final num? ayahNumber;
  final String? textArabic;
  final String? textRoman;
  final String? textEnglish;
  final String? detailEnglishPopup;
  final String? detailArabicPopup;
  final DateTime? dateAdded;
  final String? addedById;
  final bool? isPublished;
  final DateTime? publishDate;

  bool isFavorite;

  factory QuranAyatModel.fromJson(Map<String, dynamic> json) {
    return QuranAyatModel(
      id: json["id"],
      surahName: json["surah_name"],
      surahNameArabic: json["title_ar"],
      ayahNumber: json["ayah_number"],
      textArabic: json["text_arabic"],
      textRoman: json["text_roman"],
      textEnglish: json["text_english"],
      detailEnglishPopup: json["detail_english_popup"],
      detailArabicPopup: json["detail_arabic_popup"],
      dateAdded: DateTime.tryParse(json["date_added"] ?? ""),
      addedById: json["added_by_id"],
      isPublished: json["is_published"],
      publishDate: DateTime.tryParse(json["publish_date"] ?? ""),
      isFavorite: json["isFavorite"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "surah_name": surahName,
    "title_ar": surahNameArabic,
    "ayah_number": ayahNumber,
    "text_arabic": textArabic,
    "text_roman": textRoman,
    "text_english": textEnglish,
    "detail_english_popup": detailEnglishPopup,
    "detail_arabic_popup": detailArabicPopup,
    "date_added": dateAdded?.toIso8601String(),
    "added_by_id": addedById,
    "is_published": isPublished,
    "publish_date": publishDate?.toIso8601String(),
    "isFavorite": isFavorite,
  };
}
