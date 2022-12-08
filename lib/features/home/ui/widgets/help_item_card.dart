import 'package:flutter/material.dart';

class HelpItemCard extends StatelessWidget {
  const HelpItemCard({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
