import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/product/provider/product_state.dart';
import 'package:restaurants/features/product/repositories/product_repositories.dart';
import 'package:restaurants/features/user/models/user_model.dart';
import 'package:restaurants/ui/error/error_screen.dart';

final productProvider = StateNotifierProvider<ProductProvider, ProductState>((ref) {
  return ProductProvider.fromRead(ref.read);
});

class ProductProvider extends StateNotifier<ProductState> {
  ProductProvider({
    required this.productRepository,
    required this.read,
  }) : super(ProductState(user: StateAsync.initial()));

  factory ProductProvider.fromRead(Reader read) {
    final productRepository = read(productRepositoryProvider);
    return ProductProvider(read: read, productRepository: productRepository);
  }

  final Reader read;
  final ProductRepository authRepository;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(user: StateAsync.loading());
    final res = await authRepository.productDetail(email, password);
    res.fold(
      (l) {
        state = state.copyWith(user: StateAsync.error(l));
        read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(user: StateAsync.success(r.user));
        read(routerProvider).router.pop();
      },
    );
  }
}