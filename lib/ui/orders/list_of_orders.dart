import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListOfOrdersScreen extends ConsumerWidget {
  const ListOfOrdersScreen({super.key});

  static const route = '/list-of-orders';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis ordenes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.only(right: 16, top: 8, bottom: 8, left: 4),
            onTap: () {},
            horizontalTitleGap: 10,
            leading: const FlutterLogo(
              size: 70,
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
            title: const Text(
              'Takuma',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                const Text('Fecha: 12/12/2021'),
                const SizedBox(height: 1),
                Text(
                  'Precio: \$ ${(index + 1) * 923}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
