import 'package:equatable/equatable.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/auth/models/auth_model.dart';

class AuthState extends Equatable {
  const AuthState({required this.authModel});

  final StateAsync<AuthModel> authModel;

  AuthState copyWith({StateAsync<AuthModel>? authModel}) {
    return AuthState(
      authModel: authModel ?? this.authModel,
    );
  }

  @override
  List<Object?> get props => [authModel];
}
