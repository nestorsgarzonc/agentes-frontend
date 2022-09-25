import 'package:equatable/equatable.dart';
import 'package:restaurants/features/user/models/user_model.dart';

class ProductDetailModel extends Equatable {
  const ProductDetailModel(this.user, this.bearerToken);

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      User.fromMap(json['user']),
      json['token'],
    );
  }

  final User user;
  final String bearerToken;

  @override
  List<Object?> get props => [user, bearerToken];
}
