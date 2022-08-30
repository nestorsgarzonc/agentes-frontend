import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/theme/theme.dart';
import 'package:restaurants/ui/on_boarding/on_boarding.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Restaurants',
      onGenerateRoute: ref.read(routerProvider).onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.myTheme(),
      initialRoute: OnBoarding.route,
      navigatorKey: ref.read(routerProvider).navigatorKey,
    );
  }
}
