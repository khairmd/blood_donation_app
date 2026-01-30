import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utilities/app_extensions.dart';

class HttpCustomException implements IOException {
  int? code;
  String? message;
  String? apiCode;

  HttpCustomException({this.code, this.message, this.apiCode = ''});

  @override
  String toString() {
    var b = StringBuffer()..write(message);
    return b.toString();
  }
}

class ConnectionTimeOutException extends DioException {
  ConnectionTimeOutException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Connection Timed out, Please try again';
  }
}

class ConnectionErrorException extends DioException {
  ConnectionErrorException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Connection Timed out, Please try again';
  }
}

class SendTimeOutException extends DioException {
  SendTimeOutException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Send Timed out, Please try again';
  }
}

class ReceiveTimeOutException extends DioException {
  ReceiveTimeOutException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Receive Timed out, Please try again';
  }
}

//**********-----STATUS CODE ERROR HANDLERS--------**********

class BadRequestException extends DioException {
  BadRequestException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Internal server error occurred, please try again later.';
  }
}

class ConflictException extends DioException {
  ConflictException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(this.exception) :
        super(requestOptions: exception.requestOptions);

  final DioException exception;

  @override
  String toString() {
    String parsedError = parseBackendExceptionMessage(exception);
    return parsedError.isNotNullAndNotEmpty
        ? parsedError : 'No internet connection detected, please try again.';
  }
}

String parseBackendExceptionMessage(DioException exception) {
  String parsedErrorMsg = "";
  if(exception.response != null && exception.response.toString().isNotNullAndNotEmpty) {
    try {
      Map res = jsonDecode(exception.response.toString()) ?? {};
      if(res.isNotEmpty && res.containsKey("message")) {
        var message = res["message"];
        if(message is List && message.isNotEmpty) {
          parsedErrorMsg = message.first.toString();
          return parsedErrorMsg;
        } else if (message is Map && message.isNotEmpty) {
          parsedErrorMsg = message.values.first.toString();
          return parsedErrorMsg;
        } else if (message is String) {
          parsedErrorMsg = message.toString().trim();
        }
      }
    } catch (e) {
      debugPrint("Error caught in => custom_exception.parseBackendExceptionMessage");
      debugPrint(e.toString());
      return parsedErrorMsg;
    }
  }
  return parsedErrorMsg;
}