import 'package:flutter/material.dart';
import 'package:restaurants/features/restaurant/models/restaurant_model.dart' as resm;

class ProductItemCard extends StatelessWidget {
  const ProductItemCard({Key? key, required this.menuItem}) : super(key: key);

  final resm.MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: ListTile(
        onTap: () {},
        enabled: menuItem.isAvaliable,
        contentPadding: const EdgeInsets.only(
          right: 5,
          top: 10,
          bottom: 10,
        ),
        horizontalTitleGap: 10,
        leading: Image.network(
          menuItem.imgUrl,
          width: 100,
        ),
        title: Text(menuItem.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(menuItem.name),
            const SizedBox(height: 5),
            Text(
              menuItem.isAvaliable ? '\$ ${menuItem.price}' : 'NO DISPONIBLE',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
