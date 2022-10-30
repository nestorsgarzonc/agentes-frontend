import 'dart:convert';

import 'package:equatable/equatable.dart';

class Orders extends Equatable {
  const Orders({required this.orders});

  factory Orders.fromList(List list) {
    return Orders(
      orders: List<Order>.from(list.map((x) => Order.fromMap(x))),
    );
  }

  final List<Order> orders;

  Orders copyWith({
    List<Order>? orders,
  }) {
    return Orders(
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orders': orders.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Orders(orders: $orders)';

  @override
  List<Object> get props => [orders];
}

class Order extends Equatable {
  const Order({
    required this.id,
    required this.totalPrice,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantAddress,
    required this.creationDate,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      totalPrice: map['totalPrice'] ?? 0,
      restaurantId: map['restaurantId']['_id'] ?? '',
      restaurantName: map['restaurantId']['name'] ?? '',
      restaurantImage: map['restaurantId']['logoUrl'] ?? '',
      restaurantAddress: map['restaurantId']['address'] ?? '',
      creationDate: DateTime.parse(map['createdAt']),
    );
  }

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  final String id;
  final num totalPrice;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String restaurantAddress;
  final DateTime creationDate;

  Order copyWith({
    String? id,
    num? totalPrice,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImage,
    String? restaurantAddress,
    DateTime? creationDate,
  }) {
    return Order(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantImage': restaurantImage,
      'restaurantAddress': restaurantAddress,
      'creationDate': creationDate.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Order(id: $id, totalPrice: $totalPrice, restaurantId: $restaurantId, restaurantName: $restaurantName, restaurantImage: $restaurantImage, restaurantAddress: $restaurantAddress, creationDate: $creationDate)';
  }

  @override
  List<Object> get props {
    return [
      id,
      totalPrice,
      restaurantId,
      restaurantName,
      restaurantImage,
      restaurantAddress,
      creationDate,
    ];
  }
}
