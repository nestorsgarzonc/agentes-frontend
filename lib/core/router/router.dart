import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants/ui/on_boarding/on_boarding.dart';
import 'package:restaurants/ui/table/table_qr_reader_screen.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  final goRouter = GoRouter(
    initialLocation: OnBoarding.route,
    routes: [
      GoRoute(
        path: OnBoarding.route,
        builder: (context, state) => const OnBoarding(),
      ),
      GoRoute(
        path: TableQrReaderScreen.route,
        builder: (context, state) => const TableQrReaderScreen(),
      ),
    ],
  );

  BuildContext get context => goRouter.navigator!.context;

  GoRouter get router => goRouter;
}
