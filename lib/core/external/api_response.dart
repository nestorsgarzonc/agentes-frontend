import 'dart:convert';
import 'package:equatable/equatable.dart';

class ApiResponse extends Equatable {
  const ApiResponse({
    required this.response,
    required this.body,
    required this.statusCode,
    required this.path,
    required this.headers,
  });

  final String path;
  final String response;
  final Map<String, dynamic>? body;
  final int statusCode;
  final Map<String, String> headers;
  static const _decoder = JsonEncoder.withIndent('  ');

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
  bool get isError => !isSuccessful;

  Map<String, dynamic>? get responseMap {
    final body = bodyJson;
    if (body is Map<String, dynamic>) return body;
    return null;
  }

  List? get responseList {
    final body = bodyJson;
    if (body is List<dynamic>) return body;
    return null;
  }

  String get headersFormatted => _decoder.convert(headers);
  String get responseFormatted => _decoder.convert(bodyJson);

  dynamic get bodyJson => json.decode(response);

  @override
  List<Object?> get props => [body, statusCode, path, headers, response];
}
