import 'package:diner/core/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:diner/features/error/provider/error_state.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

final errorProvider = StateNotifierProvider<ErrorProvider, ErrorState>((ref) {
  return ErrorProvider.fromRead(ref);
});

class ErrorProvider extends StateNotifier<ErrorState> {
  ErrorProvider(this.socketIOHandler, {required this.ref})
      : super(const ErrorState());

  factory ErrorProvider.fromRead(Ref ref) {
    final socketIo = ref.read(socketProvider);
    return ErrorProvider(socketIo, ref: ref);
  }

  final Ref ref;
  final SocketIOHandler socketIOHandler;

  Future<void> listenError() async {
    socketIOHandler.onMap(SocketConstants.error, (data) async {
      if (data.isNotEmpty && !data.containsKey('reason')) {
        return;
      }
    CustomSnackbar.showSnackBar(ref.read(routerProvider).context, data['reason'].toString());
    }
  );}
}