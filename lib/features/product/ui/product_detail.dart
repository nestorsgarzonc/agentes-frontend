// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:oyt_front_widgets/loading/screen_loading_widget.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:oyt_front_table/models/users_table.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';
import 'package:diner/features/auth/provider/auth_provider.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:diner/features/product/provider/product_provider.dart';
import 'package:diner/features/home/ui/topping_options_checkbox.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';
import 'package:oyt_front_widgets/bottom_sheet/base_bottom_sheet.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/widgets/bottom_sheet/not_authenticated_bottom_sheet.dart';
import 'package:oyt_front_widgets/widgets/custom_text_field.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({
    super.key,
    required this.productId,
    this.order,
  });
  static const route = '/product-detail';

  final String productId;
  final ProductDetailModel? order;

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
    _notesController.text = widget.order?.note ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).productDetail(widget.productId);
    });
    _scrollController.addListener(scollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scollListener);
    _scrollController.dispose();
    ref.invalidate(productProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final tableProv = ref.watch(tableProvider);
    return Scaffold(
      body: productState.productDetail.on(
        onError: (e) => ErrorScreen(error: e.message),
        onLoading: () => const ScreenLoadingWidget(),
        onInitial: () => const ScreenLoadingWidget(),
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
                  background: Stack(
                    children: [
                      ImageApi(
                        data.imgUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(color: Colors.black.withOpacity(0.2)),
                    ],
                  ),
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
                    ToppingOptionsCheckbox(
                      toppings: data.toppings,
                      onAdd: onAddTopping,
                      orderedToppings: widget.order?.toppings,
                    ),
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
                widget.order == null
                    ? CustomElevatedButton(
                        onPressed: tableProv.tableUsers.on(
                          onData: (data) => data.tableStatus == TableStatus.ordering
                              ? _onAddToOrder
                              : () => ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'No puedes agregar productos si no estás ordenando.',
                                      ),
                                    ),
                                  ),
                          onError: (e) => () {},
                          onLoading: () => () {},
                          onInitial: () => () {},
                        ),
                        child: Text('Agregar \$ ${CurrencyFormatter.format(totalWithToppings)}'),
                      )
                    : Column(
                        children: [
                          CustomElevatedButton(
                            onPressed: _modifyItem,
                            child: Text(
                              'Modificar orden \$ ${CurrencyFormatter.format(totalWithToppings)}',
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                            onPressed: _showBottomSheet,
                            child: const Text('Eliminar orden'),
                          )
                        ],
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
      total = widget.order?.price ?? data.price;
      totalWithToppings = widget.order?.totalWithToppings ?? data.price;
      isCreated = true;
      if (mounted) setState(() {});
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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BaseBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Estás seguro que deseas elimnar este plato de la orden?'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _deleteItem,
                child: const Text('Sí'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('No'),
              )
            ],
          ),
        );
      },
    );
  }

  void _deleteItem() {
    final userState = ref.read(authProvider).authModel;
    if (userState.data == null) {
      NotAuthenticatedBottomSheet.show(context);
      return;
    }
    final newProduct = widget.order?.copyWith(
      note: _notesController.text,
      toppings: toppings,
      totalWithToppings: totalWithToppings,
    );
    if (newProduct == null) return;
    ref.read(productProvider.notifier).deleteItem(newProduct);
    GoRouter.of(context).pop();
  }

  void _modifyItem() {
    final editProduct = widget.order?.copyWith(
      note: _notesController.text,
      toppings: toppings,
      totalWithToppings: totalWithToppings,
    );
    if (editProduct == null) return;
    ref.read(productProvider.notifier).editItem(editProduct);
    GoRouter.of(context).pop();
  }
}
