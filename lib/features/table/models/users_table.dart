import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:restaurants/features/product/models/product_model.dart';

class UsersTable extends Equatable {
  const UsersTable({
    required this.users,
    required this.userName,
  });

  factory UsersTable.fromMap(Map<String, dynamic> map) {
    return UsersTable(
      users: List<UserTable>.from(map['table']['usersConnected']?.map((x) => UserTable.fromMap(x))),
      userName: map['userName'] ?? '',
    );
  }

  factory UsersTable.fromJson(String source) => UsersTable.fromMap(json.decode(source));

  final List<UserTable> users;
  final String? userName;

  @override
  List<Object?> get props => [users, userName];

  UsersTable copyWith({
    List<UserTable>? users,
    String? userName,
  }) {
    return UsersTable(
      users: users ?? this.users,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users.map((x) => x.toMap()).toList(),
      'userName': userName,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'UsersTable(users: $users, userName: $userName)';
}

class UserTable extends Equatable {
  const UserTable({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.orderProducts,
  });

  factory UserTable.fromMap(Map<String, dynamic> map) {
    return UserTable(
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
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
  final List<ProductDetailModel> orderProducts;

  @override
  List<Object?> get props => [userId, firstName, lastName, orderProducts];

  UserTable copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    List<ProductDetailModel>? orderProducts,
  }) {
    return UserTable(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
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
