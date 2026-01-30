import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:blood_donation_app/utilities/app_url.dart';
import 'package:blood_donation_app/utilities/shared_preference.dart';

import 'custom_response_handler.dart';
import 'exception_interceptors.dart';

class ApiClient {
  final dio = createDio();
  String _token = "";
  String _apiKey = "";

  ApiClient._internal();

  static final _singleton = ApiClient._internal();

  factory ApiClient() => _singleton;

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: AppUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.addAll({ErrorInterceptor(dio)});
    return dio;
  }

  String get token => _token;

  set token(String? value) {
    if (value != null && value.isNotEmpty) {
      _token = value;
    }
  }

  String get apiKey => _apiKey;

  set apiKey(String? value) {
    if (value != null && value.isNotEmpty) {
      _apiKey = value;
    }
  }

  clearKeyToken() {
    _token = "";
    _apiKey = "";
  }

  ///[GET] We will use this method inorder to process get requests
  Future<ApiResponse> get(
    String path, {
    String? token,
    Map<String, dynamic>? customHeaders,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = false,
    bool printLogs = true,
    bool setBranchID = true,
  }) async {
    await checkInternetAvailable();
    if (addRequestInterceptor) {
      // dio.interceptors
      //     .add(RequestInterceptor(dio, apiKey: apiKey, token: token));
      // dio.interceptors
      //     .add(LoggingInterceptor(endpoint: path, queryParameters: queryParameters,));
    }
    if (printLogs) {
      log("URL: ${dio.options.baseUrl + path}");
      log(
        options != null
            ? options.toString()
            : requestHeaders(token, setBranchId: setBranchID).toString(),
      );
      log("Query Parameters: $queryParameters");
    }
    Response res = await dio.get(
      dio.options.baseUrl + path,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      options: options ?? Options(headers: requestHeaders(token, setBranchId: setBranchID)),
      queryParameters: queryParameters,
    );
    return ApiResponse.processResponse(res, showLogs: printLogs);
  }

  ///[POST] We will use this method inorder to process post requests
  Future<ApiResponse> post(
    String path, {
    String? token,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool addRequestInterceptor = false,
    bool isFormData = false,
    bool setBranchID = true,
  }) async {
    await checkInternetAvailable();
    log("URL: ${dio.options.baseUrl + path}");
    log(
      options != null
          ? options.toString()
          : requestHeaders(
            token,
            contentType: isFormData ? "multipart/form-data" : null,
          ).toString(),
    );
    if (!isFormData) {
      log("Request body:: ${jsonEncode(data)}");
    } else {
      log("Request body: ${data.toString()}");
    }
    if (addRequestInterceptor) {
      // dio.interceptors
      //     .add(RequestInterceptor(dio, apiKey: apiKey, token: token));
      // dio.interceptors
      //     .add(LoggingInterceptor(endpoint: path, queryParameters: queryParameters, body: data));
    }
    Response res = await dio.post(
      dio.options.baseUrl + path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
      options: options ?? Options(headers: requestHeaders(token, setBranchId: setBranchID)),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
    return ApiResponse.processResponse(res);
  }

  Future<ApiResponse> patch(
    String path, {
    String? token,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isFormData = false,
    bool setBranchID = true,
  }) async {
    await checkInternetAvailable();
    log("URL: ${dio.options.baseUrl + path}");
    log(
      options != null
          ? options.toString()
          : requestHeaders(token, setBranchId: setBranchID).toString(),
    );
    if (!isFormData) {
      log("Request body: ${jsonEncode(data)}");
    } else {
      log("Request body: ${data.toString()}");
    }
    Response res = await dio.patch(
      dio.options.baseUrl + path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
      options: options ?? Options(headers: requestHeaders(token, setBranchId: setBranchID)),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
    return ApiResponse.processResponse(res);
  }

  Future<ApiResponse> delete(
    String path, {
    String? token,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isFormData = false,
  }) async {
    await checkInternetAvailable();
    log("URL: ${dio.options.baseUrl + path}");
    log(
      options != null
          ? "${options.headers.toString()} \n ${options.receiveTimeout?.inSeconds}"
          : requestHeaders(token).toString(),
    );
    Response res = await dio.delete(
      dio.options.baseUrl + path,
      data: data,
      queryParameters: queryParameters,
      options: options ?? Options(headers: requestHeaders(token)),
      cancelToken: cancelToken,
    );
    return ApiResponse.processResponse(res);
  }

  Future<ApiResponse> put(
    String path, {
    String? token,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool isFormData = false,
  }) async {
    await checkInternetAvailable();
    log("URL: ${dio.options.baseUrl + path}");
    log(options != null ? options.toString() : requestHeaders(token).toString());
    if (!isFormData) {
      log("Request body: ${jsonEncode(data)}");
    } else {
      log("Request body: ${data.toString()}");
    }
    Response res = await dio.put(
      dio.options.baseUrl + path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
      options: options ?? Options(headers: requestHeaders(token)),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
    return ApiResponse.processResponse(res);
  }

  Future<void> checkInternetAvailable() async {
    // if (!NetworkController.find.isInternetAvailable.value) {
    //   throw HttpCustomException(code: 8000, message: "Please check your internet connection");
    // }
    return;
  }

  Map<String, dynamic> requestHeaders(
    String? token, {
    String? contentType,
    String? userID,
    bool setBranchId = true,
  }) {
    Map<String, String> headers = {};
    // var date = DateTime.now().toString();
    // headers['RequestDateTime'] = date;
    // headers['locale'] = LocalizationService.locale.languageCode;
    headers[HttpHeaders.contentTypeHeader] = contentType ?? "application/json";

    if (token != null || UserPreferences.authToken.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = "Bearer ${token ?? UserPreferences.authToken}";
    }
    if (userID != null) {
      headers['USER_ID'] = userID;
    }
    return headers;
  }

  ///[DOWNLOAD] We will use this method to download file from path
  Future<ApiResponse> download({
    required String path,
    required String saveFilePath,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    await checkInternetAvailable();
    log("URL: $path");
    log("Request Headers: ${headers ?? {HttpHeaders.acceptEncodingHeader: '*'}}");

    Response res = await dio.download(
      path,
      saveFilePath,
      queryParameters: queryParameters,
      options: Options(headers: headers ?? {HttpHeaders.acceptEncodingHeader: '*'}),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return ApiResponse.processResponse(res);
  }
}
