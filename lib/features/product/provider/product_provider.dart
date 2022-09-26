import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/product/provider/product_state.dart';
import 'package:restaurants/features/product/repositories/product_repositories.dart';
import 'package:restaurants/ui/error/error_screen.dart';
import 'package:restaurants/core/router/router.dart';

final productProvider = StateNotifierProvider<ProductProvider, ProductState>((ref) {
  return ProductProvider.fromRead(ref.read);
});

class ProductProvider extends StateNotifier<ProductState> {
  ProductProvider({
    required this.productRepository,
    required this.read,
  }) : super(ProductState(productDetail: StateAsync.initial()));

  factory ProductProvider.fromRead(Reader read) {
    final productRepository = read(productRepositoryProvider);
    return ProductProvider(read: read, productRepository: productRepository);
  }

  final Reader read;
  final ProductRepository productRepository;

  Future<void> productDetail(String productID)async{
    state = state.copyWith(productDetail: StateAsync.loading());
    final res = await productRepository.productDetail(productID);
    res.fold(
      (l) {
        state = state.copyWith(productDetail: StateAsync.error(l));
        read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(productDetail: StateAsync.success(r));
        read(routerProvider).router.pop();
      },
    );
  }
}