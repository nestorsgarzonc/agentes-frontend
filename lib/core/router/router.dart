import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/ui/on_boarding/on_boarding.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  final navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OnBoarding.route:
        return MaterialPageRoute(
          builder: (context) => const OnBoarding(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
