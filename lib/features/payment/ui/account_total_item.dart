import 'package:flutter/material.dart';

class AccountTotalItem extends StatelessWidget {
  const AccountTotalItem({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
  });

  final String title;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
