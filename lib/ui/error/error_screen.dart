import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurants/core/constants/lotti_assets.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({
    this.error = 'Ha ocurrido un error',
    super.key,
  });

  final String error;
  static const route = '/error';

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  static const foodIcons = [
    Icons.local_pizza,
    Icons.local_dining,
    Icons.local_drink,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.local_attraction,
    Icons.local_activity
  ];

  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final middleWidth = size.width / 2;
    final middleHeight = size.height / 2;

    final random = Random();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.redAccent,
                ],
              ),
            ),
          ),
          ...List.generate(
            random.nextInt(10) + 15,
            (index) => AnimatedPositioned(
              key: Key('$index'),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              top: _animate ? size.height * random.nextDouble() : middleHeight,
              left: _animate ? size.width * random.nextDouble() : middleWidth,
              child: Transform.rotate(
                angle: pi * random.nextDouble(),
                child: Icon(
                  foodIcons.elementAt(random.nextInt(foodIcons.length)),
                  size: 50 * random.nextDouble() + 20,
                  color: Colors.white.withOpacity(min(1, random.nextDouble() + 0.2)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 30,
            right: 30,
            bottom: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.85),
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
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
                    widget.error,
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
            ),
          ),
        ],
      ),
    );
  }
}
