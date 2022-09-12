import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/auth/provider/auth_state.dart';
import 'package:restaurants/features/auth/repositories/auth_repositories.dart';
import 'package:restaurants/features/user/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider.fromRead(ref.read);
});

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({
    required this.authRepository,
    required this.read,
  }) : super(AuthState(user: StateAsync.initial()));

  factory AuthProvider.fromRead(Reader read) {
    final authRepository = read(authRepositoryProvider);
    return AuthProvider(read: read, authRepository: authRepository);
  }

  final Reader read;
  final AuthRepository authRepository;

  Future<void> login(String email, String password) async {
    state = state.copyWith(user: StateAsync.loading());
    final res = await authRepository.login(email, password);
    res.fold(
      (l) => state = state.copyWith(user: StateAsync.error(l)),
      (r) => state = state.copyWith(user: StateAsync.success(r.user)),
    );
  }

  Future<void> register(User user) async {
    state = state.copyWith(user: StateAsync.loading());
    final res = await authRepository.register(user);
    if (res != null) return;
    
  }
}
