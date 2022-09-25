import 'package:equatable/equatable.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/user/models/user_model.dart';

class ProductState extends Equatable {
  const ProductState({
    required this.user,
  });

  final StateAsync<User> user;

  ProductState copyWith({StateAsync<User>? user}) {
    return ProductState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}
