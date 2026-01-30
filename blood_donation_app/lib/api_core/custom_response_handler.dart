import 'dart:convert';
import 'dart:developer' show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final T? data;
  final DioException? error;

  ApiResponse({this.data, this.error});

  factory ApiResponse.processResponse(Response response, {bool showLogs = true}) {
    try {
      if (!((response.statusCode! < 200) || (response.statusCode! >= 300) || (response.data == (null)))) {
        try {
          if(showLogs) {
            log("Requesting URL: ${response.requestOptions.uri}");
            log("Status Code: ${response.statusCode}");
            log("Response body: ${jsonEncode(response.data)}");
          }
        } on Exception catch (e) {
          if(showLogs) {
            log("Error in logging: ${e.toString()}");
            log("Response body: ${response.data}");
          }
        }
        return ApiResponse<T>(data: response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'HTTP Error ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse<T>(
          error: DioException(
            requestOptions: response.requestOptions, error: e.toString(),
          )
      );
    }
  }

  Future<T> processJsonInBackground(T Function(Map<String, dynamic>) responseCreator, String resp) async {
    //compute runs on a new thread. It invokes the method passed as param with the param received
    //https://flutter.dev/docs/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate
    Map<String, dynamic> map = await compute(
      decodeAsync, // method that we will invoke on background...
      resp // data that we will pass to previous method
    );
    //when decoding is done, create an instance of the type we want by executing top-level callback
    //why? Otherwise instance should be created using cumbersome generics...
    return responseCreator(map);
  }
  /// JSON parsing that will be executed in background when using it with compute()
  Map<String, dynamic> decodeAsync(String json) {
    Map map = jsonDecode(json) as Map<String, dynamic>;

    return map as Map<String, dynamic>;
  }
}