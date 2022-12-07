import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:restaurants/features/product/provider/product_state.dart';
import 'package:oyt_front_product/repositories/product_repositories.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:uuid/uuid.dart';

final productProvider = StateNotifierProvider<ProductProvider, ProductState>((ref) {
  return ProductProvider.fromRead(ref);
});

class ProductProvider extends StateNotifier<ProductState> {
  ProductProvider({
    required this.productRepository,
    required this.ref,
    required this.socketIOHandler,
  }) : super(ProductState(productDetail: StateAsync.initial()));

  factory ProductProvider.fromRead(Ref ref) {
    final productRepository = ref.read(productRepositoryProvider);
    final socketIo = ref.read(socketProvider);
    return ProductProvider(
      ref: ref,
      productRepository: productRepository,
      socketIOHandler: socketIo,
    );
  }

  final Ref ref;
  final ProductRepository productRepository;
  final SocketIOHandler socketIOHandler;

  void cleanProduct() {
    state = ProductState(productDetail: StateAsync.initial());
  }

  Future<void> productDetail(String productID) async {
    state = state.copyWith(productDetail: StateAsync.loading());
    final res = await productRepository.productDetail(productID);
    res.fold(
      (l) {
        state = state.copyWith(productDetail: StateAsync.error(l));
        ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': l.message});
      },
      (r) {
        state = state.copyWith(productDetail: StateAsync.success(r));
      },
    );
  }

  Future<void> addToOrder(ProductDetailModel product) async {
    final productJson = product.toJson();
    productJson['token'] = ref.read(authProvider).authModel.data?.bearerToken;
    productJson['tableId'] = ref.read(tableProvider).tableCode;
    productJson['uuid'] = const Uuid().v4();
    socketIOHandler.emitMap(SocketConstants.addToOrder, productJson);
  }

  Future<void> deleteItem(ProductDetailModel product) async {
    final productDelete = {
      'token': ref.read(authProvider).authModel.data?.bearerToken,
      'tableId': ref.read(tableProvider).tableCode,
      'uuid': product.uuid,
    };
    socketIOHandler.emitMap(SocketConstants.deleteItem, productDelete);
  }

  Future<void> editItem(ProductDetailModel product) async {
    final productJSON = product.toJson();
    productJSON['token'] = ref.read(authProvider).authModel.data?.bearerToken;
    productJSON['tableId'] = ref.read(tableProvider).tableCode;
    socketIOHandler.emitMap(SocketConstants.editItem, productJSON);
  }
}
