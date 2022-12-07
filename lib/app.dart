import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:restaurants/core/router/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerProv = ref.read(routerProvider);
    return MaterialApp.router(
      title: 'OYT - Dinner',
      routeInformationProvider: routerProv.goRouter.routeInformationProvider,
      routeInformationParser: routerProv.goRouter.routeInformationParser,
      routerDelegate: routerProv.goRouter.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.myTheme(),
    );
  }
}
