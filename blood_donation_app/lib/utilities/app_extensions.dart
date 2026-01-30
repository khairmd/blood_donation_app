import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:blood_donation_app/utilities/app_constants.dart';

extension StringExtensionNotNull on String {
  bool get isNotNullAndNotEmpty => isNotEmpty;

  bool get isNullOREmpty => isEmpty || this == "null";

  /// Check if not null and empty and also not equal to "null" in the String value else return empty String.
  String get checkNullCondition {
    if (isNotNullAndNotEmpty && this != "null") {
      return this;
    } else {
      return "";
    }
  }

  /// Capitalize The First Letter Of Each Word
  String get capitalizeFirstOfAll {
    if (isEmpty) return this;
    return split(" ").map((word) => word.isNotEmpty && word.length >= 2 ? "${word[0].toUpperCase()}${word.substring(1)}" : "").join(" ");
  }
}

extension StringExtensions on String? {
  /// Check both not null and not empty i.e. "".
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;

  bool get isNullOREmpty => this == null || this!.isEmpty || this == "null";

  /// Check if not null and empty and also not equal to "null" in the String value else return empty String.
  String get checkNullCondition {
    if (isNotNullAndNotEmpty && this != "null") {
      return this!;
    } else {
      return "";
    }
  }

  /// Capitalize The First Letter Of Each Word
  String get capitalizeFirstOfAll {
    if (isNullOREmpty) return "";
    return this!.split(" ").map((word) => word.isNotEmpty && word.length >= 2 ? "${word[0].toUpperCase()}${word.substring(1)}" : "").join(" ");
  }

  /// Check both not null and not empty i.e. "" and also checks if equals to the parameter string in lower case
  bool isNotNullAndNotEmptyAndEquals(String? str) => this != null && this!.isNotEmpty && this?.toLowerCase() == str?.toLowerCase();

  bool isNotNullNotEmptyAndEqualTo(obj) => this != null && this!.isNotEmpty && this?.toLowerCase() == obj.toString().toLowerCase();

  bool isNotNullEmptyAndInList(List<String> list) => this != null && this!.isNotEmpty && isInList(list);

  bool isInList(List<String> list) {
    list = list.map((e) => e.toLowerCase()).toList();
    return list.contains(this?.toLowerCase());
  }

  String get getInitials => this != null && this!.isNotEmpty ? this!.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase() : '';

  String get removeAllWhiteSpaces => isNotNullAndNotEmpty ? this!.replaceAll(RegExp(r"\s+"), "") : "";
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension DateTimeExtension on DateTime {
  /*
void main() {
  final now = DateTime.now();
  final after = now.add(Duration(days: 1));
  final before = now.subtract(Duration(days: 1));

  print(now.isAfterOrEqual(now)); // true
  print(now.isBeforeOrEqual(now)); // true

  print(now.isAfterOrEqual(before)); // true
  print(now.isAfterOrEqual(after)); // false

  print(now.isBeforeOrEqual(after)); // true
  print(now.isBeforeOrEqual(before)); // false

  print(now.isBetween(from: before, to: after)); // true
  print(now.isBetween(from: now, to: now)); // true
  print(now.isBetween(from: before, to: now)); // true
  print(now.isBetween(from: now, to: after)); // true

  print(now.isBetweenExclusive(from: before, to: now)); // false
  print(now.isBetweenExclusive(from: now, to: after)); // false
}
  */
  bool isAfterOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isAfter(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    // print("from isBeforeOrEqual $other ${isAtSameMomentAs(other)}");
    // print("to isBeforeOrEqual $other ${isBefore(other)}");
    return isAtSameMomentAs(other) || isBefore(other);
  }

  bool isBetween({required DateTime from, required DateTime to}) {
    debugPrint("from $from ${isAfterOrEqual(from)}");
    debugPrint("to $to ${isBeforeOrEqual(to)}");
    return isAfterOrEqual(from) && isBeforeOrEqual(to);
  }

  bool isBetweenExclusive({required DateTime from, required DateTime to}) {
    return isAfter(from) && isBefore(to);
  }
}

extension DateTimeExtension2 on DateTime? {
  String toFormatDateTime({String format = ''}) {
    if (this == null) return "";
    return DateFormat(format.isEmpty ? AppConstants.dateFormat : format).format(this!);
  }
}
