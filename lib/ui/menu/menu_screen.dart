import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restaurants/ui/widgets/cards/product_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          backgroundColor: Colors.grey,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(16),
            background: Stack(
              fit: StackFit.expand,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.network(
                    'https://www.eltiempo.com/files/article_main/uploads/2019/06/26/5d137de78c341.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.2)),
              ],
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://theme.zdassets.com/theme_assets/9934480/ce461620239931658904a0c5b98eec8d0c3da0a9.png',
                  height: 45,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(width: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Crepes & Waffles',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Mesa: 1A',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 100,
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final isSelected = selectedCategoryIndex == index;
                return Padding(
                  padding: EdgeInsets.only(
                    right: 15,
                    top: 2,
                    bottom: 2,
                    left: index == 0 ? 10 : 0,
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () => setState(() => selectedCategoryIndex = index),
                      child: Ink(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.grey : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            FlutterLogo(size: isSelected ? 55 : 50),
                            const Spacer(),
                            Text(
                              'Category $index',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                                fontSize: isSelected ? 16 : null,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            List.generate(
              5,
              (i) => const ProductItemCard(),
            ),
          ),
        ),
      ],
    );
  }
}
