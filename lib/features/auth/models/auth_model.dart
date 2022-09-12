import 'package:equatable/equatable.dart';
import 'package:restaurants/features/user/models/user_model.dart';

class AuthModel extends Equatable {
  const AuthModel(this.user, this.bearerToken);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      User.fromMap(json['user']),
      json['bearerToken'],
    );
  }

  final User user;
  final String bearerToken;

  @override
  List<Object?> get props => [user, bearerToken];
}
