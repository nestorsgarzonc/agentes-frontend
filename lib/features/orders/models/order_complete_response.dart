import 'dart:convert';
import 'package:equatable/equatable.dart';

class OrderCompleteResponse extends Equatable {
  const OrderCompleteResponse({
    required this.id,
    required this.totalPrice,
    required this.usersOrder,
    required this.createdAt,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.paymentWay,
    required this.tip,
    required this.tableId,
  });

  factory OrderCompleteResponse.fromMap(Map<String, dynamic> map) {
    return OrderCompleteResponse(
      id: map['_id'] ?? '',
      totalPrice: map['totalPrice'] ?? 0,
      usersOrder: List<UserOrder>.from(map['usersOrder']?.map((x) => UserOrder.fromMap(x))),
      createdAt: DateTime.parse(map['createdAt']),
      restaurantId: map['restaurantId']['_id'] ?? '',
      restaurantName: map['restaurantId']['name'] ?? '',
      restaurantLogo: map['restaurantId']['logoUrl'] ?? '',
      paymentWay: map['paymentWay'] ?? '',
      tip: map['tip'] ?? 0,
      tableId: map['tableId'] ?? '',
    );
  }

  factory OrderCompleteResponse.fromJson(String source) =>
      OrderCompleteResponse.fromMap(json.decode(source));
  final String id;
  final num totalPrice;
  final List<UserOrder> usersOrder;
  final DateTime createdAt;
  final String restaurantId;
  final String restaurantName;
  final String restaurantLogo;
  final String paymentWay;
  final num tip;
  final String tableId;

  OrderCompleteResponse copyWith({
    String? id,
    num? totalPrice,
    List<UserOrder>? usersOrder,
    DateTime? createdAt,
    String? restaurantId,
    String? restaurantName,
    String? restaurantLogo,
    String? paymentWay,
    num? tip,
    String? tableId,
  }) {
    return OrderCompleteResponse(
      id: id ?? this.id,
      totalPrice: totalPrice ?? this.totalPrice,
      usersOrder: usersOrder ?? this.usersOrder,
      createdAt: createdAt ?? this.createdAt,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantLogo: restaurantLogo ?? this.restaurantLogo,
      paymentWay: paymentWay ?? this.paymentWay,
      tip: tip ?? this.tip,
      tableId: tableId ?? this.tableId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'usersOrder': usersOrder.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantLogo': restaurantLogo,
      'paymentWay': paymentWay,
      'tip': tip,
      'tableId': tableId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'OrderCompleteResponse(id: $id, totalPrice: $totalPrice, usersOrder: $usersOrder, createdAt: $createdAt, restaurantId: $restaurantId, restaurantName: $restaurantName, restaurantLogo: $restaurantLogo, paymentWay: $paymentWay, tip: $tip, tableId: $tableId)';
  }

  @override
  List<Object> get props {
    return [
      id,
      totalPrice,
      usersOrder,
      createdAt,
      restaurantId,
      restaurantName,
      restaurantLogo,
      paymentWay,
      tip,
      tableId,
    ];
  }
}

class UserOrder extends Equatable {
  const UserOrder({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.price,
    required this.orderProducts,
  });

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    return UserOrder(
      id: map['_id'] ?? '',
      firstName: map['userId']['firstName'] ?? '',
      lastName: map['userId']['lastName'] ?? '',
      price: map['price'] ?? 0,
      orderProducts:
          List<OrderProducts>.from(map['orderProducts']?.map((x) => OrderProducts.fromMap(x))),
    );
  }

  factory UserOrder.fromJson(String source) => UserOrder.fromMap(json.decode(source));

  final String id;
  final String firstName;
  final String lastName;
  final num price;
  final List<OrderProducts> orderProducts;

  UserOrder copyWith({
    String? id,
    String? firstName,
    String? lastName,
    num? price,
    List<OrderProducts>? orderProducts,
  }) {
    return UserOrder(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      price: price ?? this.price,
      orderProducts: orderProducts ?? this.orderProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'price': price,
      'orderProducts': orderProducts.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserOrder(id: $id, firstName: $firstName, lastName: $lastName, price: $price, orderProducts: $orderProducts)';
  }

  @override
  List<Object> get props {
    return [
      id,
      firstName,
      lastName,
      price,
      orderProducts,
    ];
  }
}

class OrderProducts extends Equatable {
  const OrderProducts({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.toppings,
  });

  factory OrderProducts.fromMap(Map<String, dynamic> map) {
    return OrderProducts(
      id: map['_id'] ?? '',
      price: map['productId']['price'] ?? 0,
      name: map['productId']['name'] ?? '',
      imgUrl: map['productId']['imgUrl'] ?? '',
      toppings: List<Toppings>.from(map['toppings']?.map((x) => Toppings.fromMap(x))),
    );
  }

  factory OrderProducts.fromJson(String source) => OrderProducts.fromMap(json.decode(source));

  final String id;
  final String name;
  final num price;
  final String imgUrl;
  final List<Toppings> toppings;

  List<ToppingOptions> get getToppingOptions {
    return toppings.expand((e) => e.toppingOptions).toList();
  }

  OrderProducts copyWith({
    String? id,
    String? name,
    num? price,
    String? imgUrl,
    List<Toppings>? toppings,
  }) {
    return OrderProducts(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imgUrl: imgUrl ?? this.imgUrl,
      toppings: toppings ?? this.toppings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imgUrl': imgUrl,
      'toppings': toppings.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'OrderProducts(id: $id, name: $name, price: $price, imgUrl: $imgUrl, toppings: $toppings)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      price,
      imgUrl,
      toppings,
    ];
  }
}

class Toppings extends Equatable {
  const Toppings({
    required this.id,
    required this.name,
    required this.toppingOptions,
  });

  factory Toppings.fromMap(Map<String, dynamic> map) {
    return Toppings(
      id: map['_id'] ?? '',
      name: map['toppingId']['name'] ?? '',
      toppingOptions:
          List<ToppingOptions>.from(map['toppingOptions']?.map((x) => ToppingOptions.fromMap(x))),
    );
  }

  factory Toppings.fromJson(String source) => Toppings.fromMap(json.decode(source));

  final String id;
  final String name;
  final List<ToppingOptions> toppingOptions;

  Toppings copyWith({
    String? id,
    String? name,
    List<ToppingOptions>? toppingOptions,
  }) {
    return Toppings(
      id: id ?? this.id,
      name: name ?? this.name,
      toppingOptions: toppingOptions ?? this.toppingOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'toppingOptions': toppingOptions.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Toppings(id: $id, name: $name, toppingOptions: $toppingOptions)';

  @override
  List<Object> get props => [id, name, toppingOptions];
}

class ToppingOptions extends Equatable {
  const ToppingOptions({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ToppingOptions.fromMap(Map<String, dynamic> map) {
    return ToppingOptions(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  factory ToppingOptions.fromJson(String source) => ToppingOptions.fromMap(json.decode(source));

  final String id;
  final String name;
  final num price;

  ToppingOptions copyWith({
    String? id,
    String? name,
    num? price,
  }) {
    return ToppingOptions(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ToppingOptions(id: $id, name: $name, price: $price)';

  @override
  List<Object> get props => [id, name, price];
}
