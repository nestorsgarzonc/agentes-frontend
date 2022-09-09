import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurants/ui/menu/help_menu_screen.dart';
import 'package:restaurants/ui/menu/menu_screen.dart';
import 'package:restaurants/ui/menu/table_menu_screen.dart';

class IndexMenuScreen extends ConsumerStatefulWidget {
  const IndexMenuScreen({super.key, required this.tableId});

  final String tableId;

  static const route = '/menu';

  @override
  ConsumerState<IndexMenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<IndexMenuScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
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
        child: const [MenuScreen(), TableMenuScreen(), HelpMenuScreen()][selectedIndex],
      ),
    );
  }
}
