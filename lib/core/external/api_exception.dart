import 'package:equatable/equatable.dart';
import 'package:restaurants/core/external/api_response.dart';

class ApiException extends Equatable {
  final ApiResponse response;

  const ApiException(this.response);

  @override
  List<Object?> get props => [response];
}
