// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants/core/utils/currency_formatter.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:restaurants/features/product/models/product_model.dart';
import 'package:restaurants/features/product/provider/product_provider.dart';
import 'package:restaurants/features/product/topping_option/topping_options_checkbox.dart';
import 'package:restaurants/ui/error/error_screen.dart';
import 'package:restaurants/ui/widgets/bottom_sheet/not_authenticated_bottom_sheet.dart';
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
  List<Topping> toppings = [];
  num total = 0;
  num totalWithToppings = 0;
  bool isCreated = false;

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
        onData: (data) {
          onCreateWidget(data);
          return NestedScrollView(
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
                title: isExpanded ? const SizedBox() : Text(data.name),
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
                      '\$ ${CurrencyFormatter.format(data.price)}',
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
                    ToppingOptionsCheckbox(toppings: data.toppings, onAdd: onAddTopping),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Comentarios',
                  hintText: 'Algo que debamos saber como: sin cebolla, sin tomate, etc.',
                  maxLines: 3,
                  controller: _notesController,
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  onPressed: _onAddToOrder,
                  child: Text('Agregar \$ ${CurrencyFormatter.format(totalWithToppings)}'),
                ),
                SizedBox(height: 20.0 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          );
        },
      ),
    );
  }

  void onCreateWidget(ProductDetailModel data) {
    if (isCreated) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      total = data.price;
      totalWithToppings = data.price;
      isCreated = true;
    });
  }

  void onAddTopping(List<Topping> toAddTopping) {
    toppings = toAddTopping;
    num toppingsValue = 0;
    toppings.forEach((e) => e.options.forEach((i) => toppingsValue += i.price));
    totalWithToppings = total + toppingsValue;
    setState(() {});
  }

  void _onAddToOrder() {
    final userState = ref.read(authProvider).authModel;
    if (userState.data == null) {
      NotAuthenticatedBottomSheet.show(context);
      return;
    }
    final newProduct = ref.read(productProvider).productDetail.data!.copyWith(
          note: _notesController.text,
          toppings: toppings,
          totalWithToppings: totalWithToppings,
        );
    ref.read(productProvider.notifier).addToOrder(newProduct);
    GoRouter.of(context).pop();
  }
}
