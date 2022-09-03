import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurants/core/constants/lotti_assets.dart';
import 'package:restaurants/ui/widgets/backgrounds/animated_background.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    this.error = 'Ha ocurrido un error',
    super.key,
  });

  final String error;
  static const route = '/error';

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Column(
        children: [
          const Spacer(),
          Lottie.asset(
            LottieAssets.error,
            repeat: false,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 15),
          Text(
            '¡Oops!',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
          ),
          if (GoRouter.of(context).canPop()) ...[
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: GoRouter.of(context).pop,
              child: const Text('Volver'),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
