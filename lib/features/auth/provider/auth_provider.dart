// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/auth/provider/auth_state.dart';
import 'package:restaurants/features/auth/repositories/auth_repositories.dart';
import 'package:restaurants/features/user/models/user_model.dart';
import 'package:restaurants/ui/error/error_screen.dart';

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

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(user: StateAsync.loading());
    final res = await authRepository.login(email, password);
    res.fold(
      (l) {
        state = state.copyWith(user: StateAsync.error(l));
        read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(user: StateAsync.success(r.user));
        read(routerProvider).router.pop();
      },
    );
  }

  Future<void> register(User user, BuildContext context) async {
    state = state.copyWith(user: StateAsync.loading());
    final res = await authRepository.register(user);
    if (res != null) {
      state = state.copyWith(user: StateAsync.error(res));
      read(routerProvider).router.push(ErrorScreen.route, extra: {'error': res.message});
      return;
    }
    await login(email: user.email, password: user.password ?? '');
    read(routerProvider).router.pop();
  }

  Future<void> restorePassword(String email) async {
    final res = await authRepository.restorePassword(email);
    if (res != null) return;
  }

  Future<void> getUserByToken() async {
    state = state.copyWith(user: StateAsync.loading());
    final res = await authRepository.getUserByToken();
    res.fold(
      (l) => state = state.copyWith(user: StateAsync.error(l)),
      (r) {
        if (r == null) {
          state = state.copyWith(user: StateAsync.initial());
          return;
        }
        state = state.copyWith(user: StateAsync.success(r));
      },
    );
  }
}
