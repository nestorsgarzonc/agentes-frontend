import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/features/product/provider/product_provider.dart';
import 'package:restaurants/features/product/topping_option/topping_options_checkbox.dart';
import 'package:restaurants/ui/error/error_screen.dart';
import '../widgets/buttons/custom_elevated_button.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.productId});
  static const route = '/product-detail';

  final String productId;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  bool isExpanded = true;
  final _scrollController = ScrollController();

  int foodQuantity = 0, mainProductPrice = 13500, toppingsPrices = 600, total = 0;
  bool isSelectedA = false, isSelectedB = false;

  void scollListener() {
    if (_scrollController.offset >= 100) {
      setState(() {
        isExpanded = false;
      });
    } else {
      setState(() {
        isExpanded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).productDetail(widget.productId);
    });
    _scrollController.addListener(scollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      body: productState.productDetail.on(
        onError: (e) => ErrorScreen(error: e.message),
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onInitial: () => const Center(child: CircularProgressIndicator()),
        onData: (data) =>
            //data.toppings[0]. options[0].
            NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: false,
              snap: false,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              pinned: true,
              expandedHeight: 160,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(data.imgUrl, fit: BoxFit.cover),
              ),
              title: isExpanded ? const SizedBox() : const Text('Detalle del producto'),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${data.price}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(data.description),
                  const SizedBox(height: 20),
                  const Text(
                    'Toppings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ToppingOptionsCheckbox(
                    toppings: data.toppings,
                    onAdd: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              CustomElevatedButton(
                onPressed: () {},
                child: const Text('Agregar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
