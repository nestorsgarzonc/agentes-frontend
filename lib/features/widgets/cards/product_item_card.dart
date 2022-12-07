import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:restaurants/features/restaurant/models/restaurant_model.dart' as resm;
import 'package:restaurants/features/product/ui/product_detail.dart';

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
        onTap: () => GoRouter.of(context).push('${ProductDetail.route}?productId=${menuItem.id}'),
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
            if (menuItem.description.isNotEmpty)
              Text(
                menuItem.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 5),
            Text(
              menuItem.isAvaliable
                  ? '\$ ${CurrencyFormatter.format(menuItem.price)}'
                  : 'NO DISPONIBLE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: menuItem.isAvaliable ? Colors.black : Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
