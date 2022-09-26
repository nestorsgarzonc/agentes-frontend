import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'],
      confirmPassword: map['confirm-password'],
      email: map['email'] ?? '',
      phone: map['phone']?.toInt() ?? 0,
      rol: map['rol'],
      ordersStory: List<String>.from(map['ordersStory']),
      address: map['address'],
      deviceToken: map['deviceToken'],
      tokenType: map['tokenType'],
    );
  }

  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.rol,
    this.ordersStory = const [],
    this.address,
    this.deviceToken,
    this.tokenType,
    this.password,
    this.confirmPassword,
  });

  final String firstName;
  final String lastName;
  final String? password;
  final String? confirmPassword;
  final String email;
  final int phone;
  final String? rol;
  final List<String> ordersStory;
  final String? address;
  final String? deviceToken;
  final String? tokenType;

  User copyWith({
    String? firstName,
    String? lastName,
    String? password,
    String? confirmPassword,
    String? email,
    int? phone,
    String? rol,
    List<String>? ordersStory,
    String? address,
    String? deviceToken,
    String? tokenType,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      rol: rol ?? this.rol,
      ordersStory: ordersStory ?? this.ordersStory,
      address: address ?? this.address,
      deviceToken: deviceToken ?? this.deviceToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        password,
        confirmPassword,
        email,
        phone,
        rol,
        ordersStory,
        address,
        deviceToken,
        tokenType,
      ];

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'confirm-password': confirmPassword,
      'email': email,
      'phone': phone,
      if (rol != null) 'rol': rol,
      'ordersStory': ordersStory,
      'address': address,
      'deviceToken': deviceToken,
      'tokenType': tokenType,
    };
  }

  String toJson() => json.encode(toMap());
}
