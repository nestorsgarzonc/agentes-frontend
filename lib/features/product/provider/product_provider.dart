import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/product/provider/product_state.dart';
import 'package:restaurants/features/product/repositories/product_repositories.dart';

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

  
}