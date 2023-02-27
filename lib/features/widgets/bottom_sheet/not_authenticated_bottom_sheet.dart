import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:oyt_front_widgets/bottom_sheet/bottom_sheet_constants.dart';
import 'package:diner/features/auth/ui/login_screen.dart';
import 'package:oyt_front_widgets/bottom_sheet/base_bottom_sheet.dart';

class NotAuthenticatedBottomSheet extends StatelessWidget {
  const NotAuthenticatedBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: BottomSheetConstants.shape,
      builder: (context) => const NotAuthenticatedBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '¡Alto ahi marinero!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 10),
          Lottie.asset(
            LottieAssets.sailor,
            height: 170,
            width: double.infinity,
          ),
          const SizedBox(height: 10),
          Text(
            'Para continuar debes estar autenticado',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              GoRouter.of(context).push(LoginScreen.route);
            },
            child: const Text('Autenticarme'),
          ),
          SizedBox(height: 10 + MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
