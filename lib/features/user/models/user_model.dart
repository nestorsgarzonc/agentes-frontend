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
      id: map['_id'] ?? '',
    );
  }

  const User({
    required this.firstName,
    required this.lastName,
    this.password,
    this.confirmPassword,
    required this.email,
    required this.phone,
    required this.rol,
    this.ordersStory = const [],
    this.address,
    this.deviceToken,
    this.tokenType,
    this.id,
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
  final String? id;

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
    String? id,
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
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props {
    return [
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
      id,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'confirm-password': confirmPassword,
      'email': email,
      'phone': phone,
      'rol': rol ?? 'customer',
      'ordersStory': ordersStory,
      'address': address,
      'deviceToken': deviceToken,
      'tokenType': tokenType,
      '_id': id,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, password: $password, confirmPassword: $confirmPassword, email: $email, phone: $phone, rol: $rol, ordersStory: $ordersStory, address: $address, deviceToken: $deviceToken, tokenType: $tokenType, id: $id)';
  }
}
