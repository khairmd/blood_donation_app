import 'app_exports.dart';

/// Custom TextInputFormatter to validate the TextEditing field starting
/// to be either a-zA-z or 0-9. Not a space.
class BlankSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    bool isSpaceEntered = newValue.text.startsWith(" ");
    var res = isSpaceEntered ? oldValue : newValue;
    return res;
  }
}
String? validateName(String? value) {
  String? msg;

  if (value!.isEmpty) {
    msg = "Name is required";
  } else if (value.length < 3) {
    msg = "Name must be at least 3 characters long";
  } else if (value.contains(RegExp(r'[0-9]'))) {
    msg = "Name cannot contain numbers";
  } else if (value.contains(RegExp(r'[^\w\s\.\-]'))) {
    msg = "Name can only contain letters, spaces, periods, and hyphens";
  }

  return msg;
}
String? validateEmail(value) {
  String? msg;
  RegExp regex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value!.isEmpty) {
    msg = "Email address is required";
  } else if (!regex.hasMatch(value)) {
    msg = "Please provide a valid email address";
  }
  return msg;
}
String? validatePassword(String? value) {
  String? msg;
  if (value!.isEmpty) {
    msg = "Password is required";
  } else if (value.length < 4) {
    msg = "Password must be at least 4 characters long";
  }
  return msg;
}
String? validateConfirmPassword(String? pwd, String? confirmPwd) {
  String? msg;
  if (confirmPwd!.isEmpty) {
    msg = "Confirm Password is required";
  } else if (pwd != confirmPwd) {
    msg = "Confirm Password does not matched.";
  }
  return msg;
}
String? validatePhoneNum(String? value) {
  String? msg;
  if (value!.isEmpty) {
    msg = "Phone Number is required.";
  } else if (value.length < 12) {
    msg = "Phone Number must be greater than 12 character.";
  }
  return msg;
}
String? validateInputData(value, validatorRequired) {
  String? msg;
  if (validatorRequired == true) {
    if (value == null || value == "") {
      msg = "This field is required.";
    }
  }
  return msg;
}