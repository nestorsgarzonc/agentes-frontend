import 'dart:convert';

import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  factory RestaurantModel.fromJson(String source) => RestaurantModel.fromMap(json.decode(source));

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone']?.toInt() ?? 0,
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      categories: List<Menu>.from(map['menu']?.map((x) => Menu.fromMap(x))),
    );
  }

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.categories,
  });

  final String id;
  final String name;
  final int phone;
  final String email;
  final String address;
  final String description;
  final String imageUrl;
  final List<Menu> categories;

  @override
  List<Object?> get props => [id, name, phone, email, address, description, imageUrl, categories];

  RestaurantModel copyWith({
    String? id,
    String? name,
    int? phone,
    String? email,
    String? address,
    String? description,
    String? imageUrl,
    List<Menu>? categories,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'description': description,
      'imageUrl': imageUrl,
      'menu': categories.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Menu extends Equatable {
  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source));

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      description: map['description'] ?? '',
      menuItems: List<MenuItem>.from(map['menuItems']?.map((x) => MenuItem.fromMap(x))),
      isAvaliable: map['isAvaliable'] ?? false,
    );
  }
  const Menu({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.menuItems,
    required this.isAvaliable,
  });

  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final List<MenuItem> menuItems;
  final bool isAvaliable;

  @override
  List<Object?> get props => [id, name, imgUrl, description, menuItems, isAvaliable];

  Menu copyWith({
    String? id,
    String? name,
    String? imgUrl,
    String? description,
    List<MenuItem>? menuItems,
    bool? isAvaliable,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      description: description ?? this.description,
      menuItems: menuItems ?? this.menuItems,
      isAvaliable: isAvaliable ?? this.isAvaliable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'imgUrl': imgUrl,
      'description': description,
      'menuItems': menuItems.map((x) => x.toMap()).toList(),
      'isAvaliable': isAvaliable,
    };
  }

  String toJson() => json.encode(toMap());
}

class MenuItem extends Equatable {
  factory MenuItem.fromJson(String source) => MenuItem.fromMap(json.decode(source));

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      imgUrl: map['imgUrl'] ?? '',
      isAvaliable: map['isAvaliable'] ?? false,
    );
  }
  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.isAvaliable,
  });

  final String id;
  final String name;
  final int price;
  final String imgUrl;
  final bool isAvaliable;

  @override
  List<Object?> get props => [id, name, price, imgUrl, isAvaliable];

  MenuItem copyWith({
    String? id,
    String? name,
    int? price,
    String? imgUrl,
    bool? isAvaliable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imgUrl: imgUrl ?? this.imgUrl,
      isAvaliable: isAvaliable ?? this.isAvaliable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'imgUrl': imgUrl,
      'isAvaliable': isAvaliable,
    };
  }

  String toJson() => json.encode(toMap());
}