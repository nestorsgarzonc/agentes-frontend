import 'package:diner/core/utils/auth_utils.dart';
import 'package:diner/features/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:diner/features/auth/provider/auth_provider.dart';
import 'package:diner/features/restaurant/provider/restaurant_provider.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/home/ui/help_menu_screen.dart';
import 'package:diner/features/home/ui/menu_screen.dart';
import 'package:diner/features/home/ui/table_menu_screen.dart';

class IndexMenuScreen extends ConsumerStatefulWidget {
  const IndexMenuScreen({
    super.key,
    required this.tableId,
    required this.restaurantId,
  });

  final String? tableId;
  final String? restaurantId;

  static const route = '/menu';

  @override
  ConsumerState<IndexMenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<IndexMenuScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(tableProvider.notifier).onSetTableCode(
            tableId: widget.tableId,
            restaurantId: widget.restaurantId,
          );
      ref.read(restaurantProvider.notifier).getMenu();
      ref.read(authProvider.notifier).getUserByToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ref.watch(tableProvider).tableId == null
          ? const SizedBox.shrink()
          : NavigationBar(
              height: 55,
              selectedIndex: selectedIndex,
              onDestinationSelected: handleOnNavigate,
              destinations: const [
                NavigationDestination(
                  icon: Icon(FontAwesomeIcons.utensils),
                  label: 'Menu',
                ),
                NavigationDestination(
                  icon: Icon(Icons.table_bar_outlined),
                  label: 'Mesa',
                ),
                NavigationDestination(
                  icon: Icon(Icons.support_agent_rounded),
                  label: 'Ayuda',
                ),
              ],
            ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: const [
          MenuScreen(),
          TableMenuScreen(),
          HelpMenuScreen()
        ][ref.watch(homeScreenProvider)],
      ),
    );
  }

  void handleOnNavigate(int index) {
    if (index != 1) {
      ref.read(homeScreenProvider.notifier).onNavigate(index);
      return;
    }
    AuthUtils.onVerification(ref, () => ref.read(homeScreenProvider.notifier).onNavigate(index));
  }
}
