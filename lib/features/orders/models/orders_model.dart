import 'dart:convert';

import 'package:equatable/equatable.dart';

class Orders extends Equatable {
  const Orders({
    required this.orders,
  });

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      orders: List.from(map['orders']),
    );
  }

  factory Orders.fromJson(String source) => Orders.fromMap(json.decode(source));

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

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Orders(orders: $orders)';
}
