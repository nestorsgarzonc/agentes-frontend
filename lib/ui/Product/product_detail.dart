import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/features/product/provider/product_provider.dart';
import 'package:restaurants/ui/error/error_screen.dart';
import 'package:restaurants/ui/widgets/custom_text_field.dart';
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
  final _notesController = TextEditingController();

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
        onData: (data) => NestedScrollView(
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
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
                  ListView(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    children: [
                      CheckboxListTile(
                        title: Text.rich(
                          TextSpan(
                            text: 'Papas fritas\n',
                            children: <TextSpan>[
                              TextSpan(
                                text: '${String.fromCharCode(036)} $toppingsPrices',
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        value: isSelectedA,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (foodQuantity != 0) {
                              isSelectedA = newValue!;
                              calculateTotal();
                            }
                          });
                        },
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: const Image(
                            height: 40.0,
                            width: 40.0,
                            image: NetworkImage(
                              'https://www.cardamomo.news/__export/1621290930734/sites/debate/img/2021/05/17/papas_fritas_crop1621290739319.jpeg_1753094345.jpeg',
                            ),
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text.rich(
                          TextSpan(
                            text: 'Guacamole\n',
                            children: <TextSpan>[
                              TextSpan(
                                text: '${String.fromCharCode(036)} $toppingsPrices',
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        value: isSelectedB,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (foodQuantity != 0) {
                              isSelectedB = newValue!;
                              calculateTotal();
                            }
                          });
                        },
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: const Image(
                            height: 40.0,
                            image: NetworkImage(
                              'https://www.mylatinatable.com/wp-content/uploads/2018/09/guacamole-foto-heroe-500x500.jpg',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                label: 'Comentarios',
                hintText: 'Algo que debamos saber como: sin cebolla, sin tomate, etc.',
                maxLines: 3,
                controller: _notesController,
              ),
              const SizedBox(height: 20.0),
              CustomElevatedButton(
                onPressed: _onAddToOrder,
                child: const Text('Agregar'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onAddToOrder() {
    //TODO: FINISH
    // final newProduct=ref.read(productProvider).productDetail.data!.copyWith(
    //   quantity: foodQuantity,
    //   notes: _notesController.text,
    //   toppings: [isSelectedA, isSelectedB],
    // );
    // ref.read(productProvider.notifier).addToOrder(newProduct);
  }

  void calculateTotal() {
    total = foodQuantity * mainProductPrice;
    if (isSelectedA && foodQuantity != 0) {
      total += toppingsPrices;
    }
    if (isSelectedB && foodQuantity != 0) {
      total += toppingsPrices;
    }
    setState(() {});
  }

  void addToFoodQuantity() {
    foodQuantity++;
    calculateTotal();
    setState(() {});
  }

  void removeFromFoodQuantity() {
    if (foodQuantity <= 0) {
      return;
    }
    foodQuantity--;
    calculateTotal();
    setState(() {});
  }
}
