import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_front_core/validators/text_form_validator.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/features/auth/models/connect_socket.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:restaurants/features/table/models/change_table_status.dart';
import 'package:restaurants/features/table/models/users_table.dart';
import 'package:restaurants/features/table/provider/table_state.dart';
import 'package:restaurants/ui/menu/index_menu_screen.dart';
import 'package:restaurants/ui/on_boarding/on_boarding.dart';
import 'package:restaurants/ui/widgets/snackbar/custom_snackbar.dart';

final tableProvider = StateNotifierProvider<TableProvider, TableState>((ref) {
  return TableProvider.fromRead(ref);
});

class TableProvider extends StateNotifier<TableState> {
  TableProvider(this.socketIOHandler, {required this.ref})
      : super(TableState(tableUsers: StateAsync.initial()));

  factory TableProvider.fromRead(Ref ref) {
    final socketIo = ref.read(socketProvider);
    return TableProvider(socketIo, ref: ref);
  }

  final Ref ref;
  final SocketIOHandler socketIOHandler;

  Future<void> onReadTableCode(String code) async {
    final validationError = TextFormValidator.tableCodeValidator(code);
    if (validationError != null) {
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, validationError);
      return;
    }
    GoRouter.of(ref.read(routerProvider).context).go('${IndexMenuScreen.route}?tableId=$code');
  }

  void onClearTableCode() {
    state = state.copyWith(tableCode: null);
  }

  void onSetTableCode(String code) {
    final validationError = TextFormValidator.tableCodeValidator(code);
    if (validationError != null) {
      GoRouter.of(ref.read(routerProvider).context).go(OnBoarding.route);
      CustomSnackbar.showSnackBar(ref.read(routerProvider).context, validationError);
      return;
    }
    state = state.copyWith(tableCode: code);
  }

  Future<void> listenTableUsers() async {
    socketIOHandler.onMap(SocketConstants.onNewUserJoined, (data) {
      final tableUsers = UsersTable.fromMap(data);
      if (!state.isFirstTime) {
        CustomSnackbar.showSnackBar(
          ref.read(routerProvider).context,
          'Se ha unido ${tableUsers.userName}',
        );
      }
      Logger.log('################# START onNewUserJoined #################');
      Logger.log(tableUsers.toString());
      Logger.log('################# END onNewUserJoined #################');
      state = state.copyWith(tableUsers: StateAsync.success(tableUsers), isFirstTime: false);
    });
  }

  Future<void> listenListOfOrders() async {
    socketIOHandler.onMap(SocketConstants.listOfOrders, (data) async {
      if (data.isEmpty || data['table'] == null) {
        ref.read(authProvider.notifier).logout(logoutMessage: 'La mesa ha sido cerrada.');
        ref.read(routerProvider).router.go(OnBoarding.route);
        return;
      }
      final tableUsers = UsersTable.fromMap(data);
      Logger.log('################# START listenListOfOrders #################');
      Logger.log(tableUsers.toString());
      Logger.log('################# END listenListOfOrders #################');
      state = state.copyWith(tableUsers: StateAsync.success(tableUsers), isFirstTime: false);
    });
  }

  Future<void> stopCallingWaiter() async {
    socketIOHandler.emitMap(
      SocketConstants.stopCallWaiter,
      ConnectSocket(
        tableId: state.tableCode ?? '',
        token: ref.read(authProvider).authModel.data?.bearerToken ?? '',
      ).toMap(),
    );
  }

  Future<void> callWaiter() async {
    socketIOHandler.emitMap(
      SocketConstants.callWaiter,
      ConnectSocket(
        tableId: state.tableCode ?? '',
        token: ref.read(authProvider).authModel.data?.bearerToken ?? '',
      ).toMap(),
    );
  }

  Future<void> changeStatus(TableStatus status) async {
    socketIOHandler.emitMap(
      SocketConstants.changeTableStatus,
      ChangeTableStatus(
        tableId: state.tableCode ?? '',
        token: ref.read(authProvider).authModel.data?.bearerToken ?? '',
        status: status,
      ).toMap(),
    );
  }

  Future<void> orderNow() async {
    socketIOHandler.emitMap(
      SocketConstants.orderNow,
      {
        'tableId': state.tableCode ?? '',
        'token': ref.read(authProvider).authModel.data?.bearerToken ?? '',
      },
    );
  }
}
