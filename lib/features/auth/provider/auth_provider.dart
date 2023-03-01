// ignore_for_file: use_build_context_synchronously
import 'package:diner/features/error/provider/error_provider.dart';
import 'package:diner/features/event_bus/provider/event_bus_provider.dart';
import 'package:diner/features/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_auth/models/connect_socket.dart';
import 'package:oyt_front_auth/models/login_model.dart';
import 'package:oyt_front_auth/models/user_model.dart';
import 'package:oyt_front_auth/repositories/auth_repositories.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/push_notifications/push_notif_provider.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:diner/core/router/router.dart';
import 'package:diner/features/auth/provider/auth_state.dart';
import 'package:diner/features/orders/provider/orders_provider.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider.fromRead(ref);
});

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({
    required this.authRepository,
    required this.ref,
    required this.socketIOHandler,
  }) : super(AuthState(authModel: StateAsync.initial()));

  factory AuthProvider.fromRead(Ref ref) {
    final authRepository = ref.read(authRepositoryProvider);
    final socketIo = ref.read(socketProvider);
    return AuthProvider(
      ref: ref,
      authRepository: authRepository,
      socketIOHandler: socketIo,
    );
  }

  final Ref ref;
  final AuthRepository authRepository;
  final SocketIOHandler socketIOHandler;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final fcmToken = await ref.read(pushNotificationsProvider).getToken();
    final loginModel = LoginModel(email: email, password: password, deviceToken: fcmToken);
    final res = await authRepository.login(loginModel);
    res.fold(
      (l) {
        state = state.copyWith(authModel: StateAsync.error(l));
        ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(authModel: StateAsync.success(r));
        startListeningSocket();
        ref.read(routerProvider).router.pop();
      },
    );
  }

  Future<void> register(User user, BuildContext context) async {
    state = state.copyWith(authModel: StateAsync.loading());
    final res = await authRepository.register(user);
    if (res != null) {
      state = state.copyWith(authModel: StateAsync.error(res));
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': res.message});
      return;
    }
    await login(email: user.email, password: user.password ?? '');
    ref.read(routerProvider).router.pop();
  }

  Future<void> logout({String? logoutMessage, bool withLeaveTable = false}) async {
    if (state.authModel.data == null) {
      ref
          .read(routerProvider)
          .router
          .push(ErrorScreen.route, extra: {'error': 'No tienes una sesion activa'});
      return;
    }
    if (withLeaveTable) {
      socketIOHandler.emitMap(
        SocketConstants.leaveTableDinner,
        ConnectSocket(
          tableId: ref.read(tableProvider).tableId ?? '',
          token: state.authModel.data?.bearerToken ?? '',
        ).toMap(),
      );
    }
    final res = await authRepository.logout();
    if (res != null) {
      state = state.copyWith(authModel: StateAsync.error(res));
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': res.message});
      return;
    }
    stopListeningSocket();
    CustomSnackbar.showSnackBar(
      ref.read(routerProvider).context,
      logoutMessage ?? 'Se ha cerrado sesion exitosamente.',
    );
    final tableId = ref.read(tableProvider).tableId;
    refreshProviders();
    if (tableId != null) {
      ref.read(tableProvider.notifier).onSetTableCode(restaurantId: null, tableId: tableId);
    }
    state = AuthState(authModel: StateAsync.initial());
    ref.read(homeScreenProvider.notifier).onNavigate(0);
  }

  void refreshProviders() {
    ref.invalidate(eventBusProvider);
    ref.invalidate(tableProvider);
    ref.invalidate(ordersProvider);
    ref.invalidate(errorProvider);
    socketIOHandler.disconnect();
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

  void stopListeningSocket() {
    socketIOHandler.disconnect();
  }

  Future<void> startListeningSocket() async {
    await socketIOHandler.connect();
    socketIOHandler.onReconnect((_) => listenSocket());
    listenSocket();
  }

  void listenSocket() {
    final socketModel = ConnectSocket(
      tableId: ref.read(tableProvider).tableId ?? '',
      token: state.authModel.data?.bearerToken ?? '',
    );
    ref.read(tableProvider.notifier).listenTableUsers();
    ref.read(eventBusProvider.notifier).startListeningSocket();
    ref.read(tableProvider.notifier).listenListOfOrders();
    ref.read(ordersProvider.notifier).listenOnPay();
    ref.read(errorProvider.notifier).listenError();
    socketIOHandler.emitMap(SocketConstants.joinSocket, socketModel.toMap());
  }
}
