import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:restaurants/core/constants/api_constants.dart';
import 'package:restaurants/core/constants/db_constants.dart';
import 'package:restaurants/core/external/api_exception.dart';
import 'package:restaurants/core/external/api_response.dart';
import 'package:restaurants/core/external/db_handler.dart';
import 'package:restaurants/core/logger/logger.dart';

final apiHandlerProvider = Provider<ApiHandler>((ref) => ApiHandlerImpl(read: ref.read));

abstract class ApiHandler {
  Future<ApiResponse> delete(String path);
  Future<ApiResponse> get(String path);
  Future<ApiResponse> patch(String path, Map<String, dynamic> body);
  Future<ApiResponse> post(String path, Map<String, dynamic> body);
  Future<ApiResponse> put(String path, Map<String, dynamic> body);
  Future<Map<String, String>> getHeaders();
  Uri getUri(String path);
  void logOnError(String path, Map<String, dynamic>? body, String exception, StackTrace stackTrace);
  void logOnStart(String path, Map<String, dynamic>? body, String method);
  void logOnSuccess(ApiResponse response);
  List<int> processBody(Map<String, dynamic> body);
}

class ApiHandlerImpl implements ApiHandler {
  const ApiHandlerImpl({required this.read});

  final Reader read;

  @override
  Future<ApiResponse> delete(String path) async {
    try {
      logOnStart(path, null, 'DELETE');
      final headers = await getHeaders();
      final res = await http.delete(getUri(path), headers: headers);
      final apiResponse = ApiResponse(
        path: path,
        body: null,
        response: res.body,
        statusCode: res.statusCode,
        headers: headers,
      );
      if (apiResponse.isError) throw ApiException(apiResponse);
      logOnSuccess(apiResponse);
      return apiResponse;
    } catch (e, s) {
      logOnError(path, null, e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<ApiResponse> get(String path) async {
    try {
      logOnStart(path, null, 'GET');
      final headers = await getHeaders();
      final res = await http.get(getUri(path), headers: headers);
      final apiResponse = ApiResponse(
        path: path,
        body: null,
        response: res.body,
        statusCode: res.statusCode,
        headers: headers,
      );
      if (apiResponse.isError) throw ApiException(apiResponse);
      logOnSuccess(apiResponse);
      return apiResponse;
    } catch (e, s) {
      logOnError(path, null, e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<ApiResponse> patch(String path, Map<String, dynamic> body) async {
    try {
      logOnStart(path, null, 'PATCH');
      final headers = await getHeaders();
      final res = await http.patch(getUri(path), headers: headers, body: processBody(body));
      final apiResponse = ApiResponse(
        path: path,
        body: body,
        response: res.body,
        statusCode: res.statusCode,
        headers: headers,
      );
      if (apiResponse.isError) throw ApiException(apiResponse);
      logOnSuccess(apiResponse);
      return apiResponse;
    } catch (e, s) {
      logOnError(path, null, e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    try {
      logOnStart(path, null, 'POST');
      final headers = await getHeaders();
      final res = await http.post(getUri(path), headers: headers, body: processBody(body));
      final apiResponse = ApiResponse(
        path: path,
        body: body,
        response: res.body,
        statusCode: res.statusCode,
        headers: headers,
      );
      if (apiResponse.isError) throw ApiException(apiResponse);
      logOnSuccess(apiResponse);
      return apiResponse;
    } catch (e, s) {
      logOnError(path, null, e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<ApiResponse> put(String path, Map<String, dynamic> body) async {
    try {
      logOnStart(path, null, 'PUT');
      final headers = await getHeaders();
      final res = await http.put(getUri(path), headers: headers);
      final apiResponse = ApiResponse(
        path: path,
        body: body,
        response: res.body,
        statusCode: res.statusCode,
        headers: headers,
      );
      if (apiResponse.isError) throw ApiException(apiResponse);
      logOnSuccess(apiResponse);
      return apiResponse;
    } catch (e, s) {
      logOnError(path, null, e.toString(), s);
      rethrow;
    }
  }

  @override
  Uri getUri(String path) {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    print(uri);
    return uri;
  }

  @override
  void logOnError(
      String path, Map<String, dynamic>? body, String exception, StackTrace stackTrace) {
    Logger.log('######## API FAILURE ########');
    Logger.log('Path: $path');
    Logger.log('Body: $body');
    Logger.logError(exception, stackTrace);
    Logger.log('######## END API FAILURE ########');
  }

  @override
  void logOnStart(String path, Map<String, dynamic>? body, String method) {
    Logger.log('######## API START ########');
    Logger.log('Path: $path');
    Logger.log('Body: $body');
    Logger.log('METHOD: $method');
    Logger.log('######## END API START ########');
  }

  @override
  void logOnSuccess(ApiResponse response) {
    Logger.log('######## API SUCCESS ########');
    Logger.log('Path: ${response.path}');
    Logger.log('Body: ${response.body}');
    Logger.log('Response: ${response.response}');
    Logger.log('StatusCode: ${response.statusCode}');
    Logger.log('Headers: ${response.headers}');
    Logger.log('######## END API SUCCESS ########');
  }

  @override
  Future<Map<String, String>> getHeaders() async {
    final token = await read(dbProvider).get(DbConstants.authBox, DbConstants.bearerTokenKey);
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'auth-token': token,
    };
  }

  @override
  List<int> processBody(Map<String, dynamic> body) => utf8.encode(json.encode(body));
}
