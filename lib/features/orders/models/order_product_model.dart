import 'dart:convert';

import 'package:equatable/equatable.dart';

class OrderProduct extends Equatable {
  const OrderProduct({
    required this.orders,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      orders: List.from(map['orders']),
    );
  }
  factory OrderProduct.fromJson(String source) => OrderProduct.fromMap(json.decode(source));

  final List orders;

  @override
  List<Object> get props => [orders];

  OrderProduct copyWith({
    List? orders,
  }) {
    return OrderProduct(
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orders': orders,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'OrderProduct(orders: $orders)';
}
