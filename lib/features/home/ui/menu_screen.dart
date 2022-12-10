import 'package:diner/features/home/ui/widgets/menu_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diner/features/restaurant/provider/restaurant_provider.dart';
import 'package:diner/features/widgets/cards/product_item_card.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';

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
      onError: (error) => Center(child: Text(error.message)),
      onLoading: () => const ScreenLoadingWidget(),
      onInitial: () => const LoadingWidget(),
      onData: (data) => CustomScrollView(
        slivers: [
          MenuAppBar(restaurantData: data),
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
                              ImageApi(
                                cat.imgUrl,
                                height: isSelected ? 48 : 45,
                                width: 100,
                                fit: BoxFit.fitHeight,
                              ),
                              const Spacer(),
                              Text(
                                cat.name,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : null,
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
