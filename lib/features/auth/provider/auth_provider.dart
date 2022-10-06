// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/constants/socket_constants.dart';
import 'package:restaurants/core/external/socket_handler.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/auth/models/connect_socket.dart';
import 'package:restaurants/features/auth/provider/auth_state.dart';
import 'package:restaurants/features/auth/repositories/auth_repositories.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/features/user/models/user_model.dart';
import 'package:restaurants/ui/error/error_screen.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider.fromRead(ref.read);
});

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({
    required this.authRepository,
    required this.read,
    required this.socketIOHandler,
  }) : super(AuthState(authModel: StateAsync.initial()));

  factory AuthProvider.fromRead(Reader read) {
    final authRepository = read(authRepositoryProvider);
    final socketIo = read(socketProvider);
    return AuthProvider(
      read: read,
      authRepository: authRepository,
      socketIOHandler: socketIo,
    );
  }

  final Reader read;
  final AuthRepository authRepository;
  final SocketIOHandler socketIOHandler;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.login(email, password);
    res.fold(
      (l) {
        state = state.copyWith(authModel: StateAsync.error(l));
        read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(authModel: StateAsync.success(r));
        startListeningSocket();
        read(routerProvider).router.pop();
      },
    );
  }

  Future<void> register(User user, BuildContext context) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.register(user);
    if (res != null) {
      state = state.copyWith(authModel: StateAsync.error(res));
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
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.getUserByToken();
    res.fold(
      (l) => state = state.copyWith(authModel: StateAsync.error(l)),
      (r) {
        if (r == null) {
          state = state.copyWith(authModel: StateAsync.initial());
          return;
        }
        startListeningSocket();
        state = state.copyWith(authModel: StateAsync.success(r));
      },
    );
  }

  Future<void> startListeningSocket() async {
    await socketIOHandler.connect();
    final socketModel = ConnectSocket(
      tableId: read(tableProvider).tableCode ?? '',
      token: state.authModel.data?.bearerToken ?? '',
    );
    read(tableProvider.notifier).listenTableUsers();
    socketIOHandler.emitMap(SocketConstants.joinSocket, socketModel.toMap());
  }
}
