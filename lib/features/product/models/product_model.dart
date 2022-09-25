import 'package:equatable/equatable.dart';
import 'package:restaurants/features/user/models/user_model.dart';

class ProductModel extends Equatable {
  const ProductModel(this.user, this.bearerToken);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      User.fromMap(json['user']),
      json['token'],
    );
  }

  final User user;
  final String bearerToken;

  @override
  List<Object?> get props => [user, bearerToken];
}
