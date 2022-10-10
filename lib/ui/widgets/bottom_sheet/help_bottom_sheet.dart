import 'package:flutter/material.dart';
import 'package:restaurants/ui/widgets/bottom_sheet/base_bottom_sheet.dart';

class HelpBottomSheet extends StatelessWidget {
  const HelpBottomSheet({super.key, required this.text, required this.title});
  final String text;
  final String title;

  static void show(BuildContext context, String text, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => HelpBottomSheet(text: text, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(Icons.close)),
            ],
          ),
          Text(
            text,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
