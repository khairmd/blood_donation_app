import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/utilities/app_globals.dart';

import '../utilities/app_extensions.dart';
import 'custom_exceptions.dart';

class ExceptionData {
  String? title;
  String? message;
  int? code;
  ExceptionData({this.title, this.message, this.code = -1});
}

class ExceptionHandler {
  static final ExceptionHandler _exceptionHandler = ExceptionHandler._internal();
  ExceptionHandler._internal();
  factory ExceptionHandler() => _exceptionHandler;

  Future<void> handleException(
    Exception e, {
    bool showDialog = true,
    String? msgText,
    String? dialogButtonText,
    VoidCallback? onBtnTap,
  }) async {
    var data = _makeException(e, msgText);

    if (showDialog && data != null && data?.message != null && !Get.isDialogOpen!) {
      AppGlobals.showAlertDialog(
        heading: data?.title,
        message: msgText ?? data.message,
        btnText: dialogButtonText,
        closeDialog: false,
        onTap: onBtnTap,
      );
    }
  }

  // e.exception.response.toString()
  // {\"message\":[\"User recently changed password! Please log in again.\"],\"error\":\"UNAUTHORIZED\",\"statusCode\":401}
  _makeException(Exception e, String? overRideMsg) {
    if (e is DioException && kDebugMode) {
      debugPrint(
        "DioException: message: ${e.message}\ntype: ${e.type}\nError:${e.error}\nStackTrace${getStackTrace(e.stackTrace)}",
      );
    }
    // jsonDecode(e.exception.response.toString());
    switch (e.runtimeType) {
      case TimeoutException || SendTimeOutException:
        return ExceptionData(
          title: "TimeoutException",
          message: overRideMsg ?? "Check your internet connection.",
        );
      case SocketException:
        return ExceptionData(
          title: "Connectivity",
          message: overRideMsg ?? "Check your internet connection.",
        );
      case HttpException:
        return ExceptionData(title: "Error", message: overRideMsg ?? (e as HttpException).message);
      case HttpCustomException:
        if ((e as HttpCustomException).code == 8000) {
          // return;
          return ExceptionData(title: "Error", message: overRideMsg ?? "No internet connection");
        }
        return ExceptionData(
          title: "Error",
          // ignore: unnecessary_cast
          message: overRideMsg ?? (e as HttpCustomException).message,
          code: e.code,
        );
      case ConnectionErrorException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case ConnectionTimeOutException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case BadRequestException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case UnauthorizedException:
        return _handleUnAuthorizeException(e, overRideMsg);
      case NotFoundException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case ConflictException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case InternalServerErrorException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case NoInternetConnectionException:
        return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
      case HandshakeException:
        return ExceptionData(
          title: "Handshake Exception",
          message: overRideMsg ?? "Connection is unstable.",
        );
      default:
        return ExceptionData(
          title: "Error",
          message: overRideMsg ?? "Something went wrong,\nPlease try again",
        );
    }
  }

  _handleUnAuthorizeException(Exception e, String? overRideMsg) {
    //   if(authenticator.getUserToken().isNullOREmpty) {
    //     Helper.showAlertDialog(
    //       heading: "Error",
    //       message: "Incorrect Email or Password"
    //     );
    //     return;
    //   } else {
    //     return ExceptionData(
    //       title: "Error", message: e.toString()
    //     );
    //   }
    String error = e.toString().toLowerCase().trim();
    if (error.removeAllWhiteSpaces.contains("loginagain") ||
        error.contains("login") ||
        error.removeAllWhiteSpaces.contains("log")) {
      AppGlobals.showAlertDialog(
        heading: "Error",
        message: overRideMsg ?? e.toString(),
        onTap: () {
          // Logout
        },
      );
      return;
    } else {
      return ExceptionData(title: "Error", message: overRideMsg ?? e.toString());
    }
  }

  String getStackTrace(dynamic stackTrace) {
    if (stackTrace is! StackTrace) return "";
    // Convert stack trace to string
    final stackTraceString = stackTrace.toString();

    // Split stack trace string by line breaks
    final lines = stackTraceString.split('\n');

    // Filter out lines containing file paths
    final filePaths =
        lines.where((line) => line.contains('.dart') && line.contains('eazio_app')).toList();

    // Join file paths into a single string
    final simplifiedStackTrace = filePaths.join('\n');

    return simplifiedStackTrace;
  }
}
