import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/ui/on_boarding/on_boarding.dart';
import 'package:restaurants/ui/table/table_qr_reader_screen.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentState!.overlay!.context;

  NavigatorState get router => navigatorKey.currentState!;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OnBoarding.route:
        return MaterialPageRoute(
          builder: (context) => const OnBoarding(),
          settings: settings,
        );
      case TableQrReaderScreen.route:
        return MaterialPageRoute(
          builder: (context) => const TableQrReaderScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
