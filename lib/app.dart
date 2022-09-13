import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/theme/theme.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ref.read(authProvider.notifier).getUserByToken());
  }

  @override
  Widget build(BuildContext context) {
    final routerProv = ref.read(routerProvider);
    return MaterialApp.router(
      title: 'Restaurants',
      routeInformationProvider: routerProv.goRouter.routeInformationProvider,
      routeInformationParser: routerProv.goRouter.routeInformationParser,
      routerDelegate: routerProv.goRouter.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.myTheme(),
    );
  }
}
