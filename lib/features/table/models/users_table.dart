import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:restaurants/features/product/models/product_model.dart';

enum TableStatus {
  empty(value: 'empty', translatedValue: 'Vacia'),
  ordering(
    value: 'ordering',
    translatedValue: 'Ordenando',
    actionButtonLabel: 'Ordenar ahora',
  ),
  waitingForFood(
    value: 'waiting for food',
    translatedValue: 'Esperando comida',
  ),
  confirmOrder(
    value: 'confirm order',
    translatedValue: 'Confirmando orden',
  ),
  eating(
    value: 'eating',
    translatedValue: 'Comiendo',
    actionButtonLabel: 'Pagar ahora',
  ),
  paying(
    value: 'paying',
    translatedValue: 'Pagando',
    actionButtonLabel: 'Ir a pagar',
  );

  const TableStatus({required this.value, required this.translatedValue, this.actionButtonLabel});
  final String value;
  final String translatedValue;
  final String? actionButtonLabel;

  static TableStatus fromString(String? value) {
    return TableStatus.values.firstWhere((e) => e.value == value, orElse: () => TableStatus.empty);
  }
}

class UsersTable extends Equatable {
  const UsersTable({
    required this.users,
    required this.userName,
    this.totalPrice,
    this.tableStatus,
    this.needsWaiter = false,
  });

  factory UsersTable.fromMap(Map<String, dynamic> map) {
    return UsersTable(
      users: List<UserTable>.from(map['table']['usersConnected']?.map((x) => UserTable.fromMap(x))),
      userName: map['userName'],
      totalPrice: map['table']['totalPrice'],
      needsWaiter: map['table']['needsWaiter'],
      tableStatus: map['table']['tableStatus'] != null
          ? TableStatus.fromString(map['table']['tableStatus'])
          : null,
    );
  }

  factory UsersTable.fromJson(String source) => UsersTable.fromMap(json.decode(source));

  final List<UserTable> users;
  final String? userName;
  final num? totalPrice;
  final TableStatus? tableStatus;
  final bool needsWaiter;

  @override
  List<Object?> get props => [users, userName, totalPrice, tableStatus, needsWaiter];

  UsersTable copyWith({
    List<UserTable>? users,
    String? userName,
    num? totalPrice,
    TableStatus? tableStatus,
    bool? needsWaiter,
  }) {
    return UsersTable(
      users: users ?? this.users,
      userName: userName ?? this.userName,
      totalPrice: totalPrice ?? this.totalPrice,
      tableStatus: tableStatus ?? this.tableStatus,
      needsWaiter: needsWaiter ?? this.needsWaiter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users.map((x) => x.toMap()).toList(),
      'userName': userName,
      'totalPrice': totalPrice,
      'tableStatus': tableStatus?.value,
      'needsWaiter': needsWaiter,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UsersTable(users: $users, userName: $userName, totalPrice: $totalPrice, tableStatus: $tableStatus, needsWaiter: $needsWaiter)';
  }
}

class UserTable extends Equatable {
  const UserTable({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.orderProducts,
    required this.price,
  });

  factory UserTable.fromMap(Map<String, dynamic> map) {
    return UserTable(
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      price: map['price'] ?? 0,
      lastName: map['lastName'] ?? '',
      orderProducts: List<ProductDetailModel>.from(
        map['orderProducts']?.map((x) => ProductDetailModel.fromJson(x)),
      ),
    );
  }
  factory UserTable.fromJson(String source) => UserTable.fromMap(json.decode(source));

  final String userId;
  final String firstName;
  final String lastName;
  final num price;
  final List<ProductDetailModel> orderProducts;

  @override
  List<Object?> get props => [userId, firstName, lastName, orderProducts, price];

  UserTable copyWith({
    String? userId,
    String? firstName,
    num? price,
    String? lastName,
    List<ProductDetailModel>? orderProducts,
  }) {
    return UserTable(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      price: price ?? this.price,
      lastName: lastName ?? this.lastName,
      orderProducts: orderProducts ?? this.orderProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'orderProducts': orderProducts.map((x) => x.toJson()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
