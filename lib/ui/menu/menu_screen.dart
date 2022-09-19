import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/features/restaurant/provider/restaurant_provider.dart';
import 'package:restaurants/ui/widgets/cards/product_item_card.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    return restaurantState.restaurant.on(
      onError: (error) => Center(
        child: Text(error.message),
      ),
      onLoading: () => const Center(child: CircularProgressIndicator()),
      onInitial: () => const Center(child: CircularProgressIndicator()),
      onData: (data) => CustomScrollView(
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
                      data.imageUrl,
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
                    data.imageUrl,
                    height: 45,
                    fit: BoxFit.fitHeight,
                  ),
                  const SizedBox(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.name,
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
              height: 120,
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.categories.length,
                itemBuilder: (context, index) {
                  final cat = data.categories[index];
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
                          height: 120,
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
                              Image.network(
                                cat.imgUrl,
                                height: isSelected ? 48 : 45,
                                width: 100,
                                fit: BoxFit.fitHeight,
                              ),
                              const Spacer(),
                              Text(
                                cat.name,
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
              data.categories[selectedCategoryIndex].menuItems
                  .map((e) => ProductItemCard(menuItem: e))
                  .toList(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }
}