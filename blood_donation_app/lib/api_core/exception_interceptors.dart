
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utilities/app_extensions.dart';
import 'custom_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  final Dio dio;

  ErrorInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        throw ConnectionErrorException(err);
      case DioExceptionType.connectionTimeout:
        throw ConnectionTimeOutException(err);
      case DioExceptionType.sendTimeout:
        throw SendTimeOutException(err);
      case DioExceptionType.receiveTimeout:
        throw ReceiveTimeOutException(err);
      case DioExceptionType.badResponse:
        log("STATUS CODE : ${err.response?.statusCode}");
        log("${err.response?.data}");
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err);
          case 401:
            throw UnauthorizedException(err);
          case 404:
            throw NotFoundException(err);
          case 409:
            throw ConflictException(err);
          case 500:
            throw InternalServerErrorException(err);
        }
        break;
      case DioExceptionType.cancel:
        log("Request Cancelled");
        break;
      case DioExceptionType.badCertificate:
        log(err.message.toString());
        throw HandshakeException(err.message.toString());
      case DioExceptionType.unknown:
        if(err.error.runtimeType == HandshakeException) {
          log(err.message.isNotNullAndNotEmpty ? err.message.toString() : err.toString());
          throw HandshakeException(err.message.toString());
        } else {
          log(err.message.toString());
          throw NoInternetConnectionException(err);
        }
      }
    return handler.next(err);
  }
}
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.endpoint, this.headers, this.queryParameters, this.body,});
  String? endpoint;
  Map<String, dynamic>? headers;
  Map<String, dynamic>? queryParameters;
  dynamic body;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print("LoggingInterceptor onRequest:");
      print(endpoint);
      print(headers ?? options.headers);
      if(queryParameters != null) {
        print(queryParameters);
      }
      if(body != null) {
        print(body);
      }
    }
    return handler.next(options);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print("LoggingInterceptor onResponse:");
      print(response.statusCode);
      print(response.headers);
      print(response.data);
    }
    super.onResponse(response, handler);
  }
}

class RequestInterceptor extends Interceptor {
  final Dio dio;
  final String apiKey;
  final String token;

  RequestInterceptor(this.dio, {required this.token, required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {'apiKey': apiKey, 'token': token};
    return handler.next(options);
  }
}
