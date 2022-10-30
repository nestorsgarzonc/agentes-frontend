import 'package:flutter/material.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:riverpod/riverpod.dart';

final dialogsProvider = Provider<CustomDialogs>((ref) {
  return CustomDialogs(ref);
});

class CustomDialogs {
  CustomDialogs(this.ref);

  final Ref ref;

  Future<void> showLoadingDialog(String? message) async {
    return showDialog(
      context: ref.read(routerProvider).context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            if (message != null)
              Text(message, style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void removeDialog() {
    Navigator.pop(ref.read(routerProvider).context);
  }
}
