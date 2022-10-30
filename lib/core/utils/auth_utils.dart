import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/ui/widgets/bottom_sheet/not_authenticated_bottom_sheet.dart';
import '../../features/auth/provider/auth_provider.dart';

class AuthUtils {
  static void onVerification(WidgetRef ref, void Function() onCorrectAuth) {
    final userState = ref.read(authProvider).authModel;
    if (userState.data != null) {
      onCorrectAuth();
      return;
    } else {
      NotAuthenticatedBottomSheet.show(ref.read(routerProvider).context);
    }
  }
}
