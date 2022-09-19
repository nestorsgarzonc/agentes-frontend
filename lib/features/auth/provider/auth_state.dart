import 'package:equatable/equatable.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/user/models/user_model.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.user,
  });

  final StateAsync<User> user;

  AuthState copyWith({StateAsync<User>? user}) {
    return AuthState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}
