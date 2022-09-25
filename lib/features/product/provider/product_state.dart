import 'package:equatable/equatable.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/ui/Product/product_detail.dart';

class ProductState extends Equatable {
  const ProductState({
    required this.productDetail,
  });

  final StateAsync<ProductDetail> productDetail;

  ProductState copyWith({StateAsync<ProductDetail>? productDetail}) {
    return ProductState(
      productDetail: productDetail ?? this.productDetail,
    );
  }

  @override
  List<Object?> get props => [productDetail];
}
