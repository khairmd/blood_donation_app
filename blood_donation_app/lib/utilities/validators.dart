class Validators {
  static String? required(String? value, {String? msg}) {
    var message = msg ?? "Required";
    if (value == null || value.isEmpty) {
      message = message;
    } else {
      return null;
    }
    return message;
  }
}
