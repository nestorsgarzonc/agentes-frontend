import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({required this.child, super.key});

  final Widget child;
  static const route = '/error';

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
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
            top: 40,
            left: 30,
            right: 30,
            bottom: 40,
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
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
