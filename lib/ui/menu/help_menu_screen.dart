import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/ui/menu/widgets/help_item_card.dart';
import 'package:restaurants/ui/widgets/bottom_sheet/help_bottom_sheet.dart';
import '../../features/menu/models/help_menu_item.dart';

class HelpMenuScreen extends ConsumerStatefulWidget {
  const HelpMenuScreen({super.key});
  static const route = '/help_menu';

  @override
  ConsumerState<HelpMenuScreen> createState() => _HelpMenuScreenState();
}

class _HelpMenuScreenState extends ConsumerState<HelpMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Necesitas ayuda?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(height: 5),
            const Text('Selecciona a continuacion el tipo de ayuda que necesitas.'),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: HelpMenuItem.items.length,
                itemBuilder: (context, index) {
                  final item = HelpMenuItem.items[index];
                  return HelpItemCard(
                    title: item.title,
                    onTap: () {
                      item.onTap == null
                          ? HelpBottomSheet.show(context, item.content, item.title)
                          : item.onTap?.call(ref);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
