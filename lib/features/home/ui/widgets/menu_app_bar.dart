import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';


class MenuAppBar extends StatelessWidget {
  const MenuAppBar({Key? key, required this.restaurantData}) : super(key: key);

  final RestaurantModel restaurantData;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.27,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.grey,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: restaurantData.imageUrl == null
                  ? const FlutterLogo()
                  : ImageApi(restaurantData.imageUrl!, fit: BoxFit.cover),
            ),
            Container(color: Colors.black.withOpacity(0.2)),
          ],
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            restaurantData.logoUrl == null
                ? const FlutterLogo()
                : ImageApi(restaurantData.logoUrl!, height: 50, width: 50),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  restaurantData.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Mesa: ${restaurantData.tableName}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
