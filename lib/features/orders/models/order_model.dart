import 'dart:convert';

import 'package:equatable/equatable.dart';

class Orders extends Equatable {
  Orders({
    required this.orders,
  });
  final List orders;

  @override
  // TODO: implement props
  List<Object> get props => [orders];

  Orders copyWith({
    List? orders,
  }) {
    return Orders(
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orders': orders,
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      orders: List.from(map['orders']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Orders.fromJson(String source) => Orders.fromMap(json.decode(source));

  @override
  String toString() => 'Orders(orders: $orders)';
}
