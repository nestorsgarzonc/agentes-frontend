import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/constants/socket_constants.dart';
import 'package:restaurants/core/external/socket_handler.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:restaurants/features/product/models/product_model.dart';
import 'package:restaurants/features/product/provider/product_state.dart';
import 'package:restaurants/features/product/repositories/product_repositories.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/error/error_screen.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:uuid/uuid.dart';

final productProvider = StateNotifierProvider<ProductProvider, ProductState>((ref) {
  return ProductProvider.fromRead(ref.read);
});

class ProductProvider extends StateNotifier<ProductState> {
  ProductProvider({
    required this.productRepository,
    required this.read,
    required this.socketIOHandler,
  }) : super(ProductState(productDetail: StateAsync.initial()));

  factory ProductProvider.fromRead(Reader read) {
    final productRepository = read(productRepositoryProvider);
    final socketIo = read(socketProvider);
    return ProductProvider(
      read: read,
      productRepository: productRepository,
      socketIOHandler: socketIo,
    );
  }

  final Reader read;
  final ProductRepository productRepository;
  final SocketIOHandler socketIOHandler;

  Future<void> productDetail(String productID) async {
    state = state.copyWith(productDetail: StateAsync.loading());
    final res = await productRepository.productDetail(productID);
    res.fold(
      (l) {
        state = state.copyWith(productDetail: StateAsync.error(l));
        read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(productDetail: StateAsync.success(r));
      },
    );
  }

  Future<void> addToOrder(ProductDetailModel product) async {
    final productJson = product.toJson();
    productJson['token'] = read(authProvider).authModel.data?.bearerToken;
    productJson['tableId'] = read(tableProvider).tableCode;
    productJson['uuid'] = const Uuid().v4();
    socketIOHandler.emitMap(SocketConstants.addToOrder, productJson);
  }

  Future<void> deleteItem(ProductDetailModel product) async {
    final productDelete = {
      'token': read(authProvider).authModel.data?.bearerToken,
      'tableId': read(tableProvider).tableCode,
      'uuid': product.uuid,
    };
    socketIOHandler.emitMap(SocketConstants.deleteItem, productDelete);
  }
}
