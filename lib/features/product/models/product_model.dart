import 'package:equatable/equatable.dart';

class ProductDetailModel extends Equatable {
  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
        id: json['_id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        uuid: json['uuid'],
        imgUrl: json['imgUrl'],
        toppings: List<Topping>.from(json['toppings'].map((x) => Topping.fromJson(x))),
        isAvaliable: json['isAvaliable'],
        categoryId: json['categoryId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        note: json['note'],
        totalWithToppings: json['totalWithToppings'],
      );

  const ProductDetailModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imgUrl,
    required this.toppings,
    required this.isAvaliable,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.note,
    this.uuid,
    this.totalWithToppings,
  });

  final String id;
  final String name;
  final int price;
  final String description;
  final String imgUrl;
  final List<Topping> toppings;
  final bool isAvaliable;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String? note;
  final num? totalWithToppings;
  final String? uuid;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'price': price,
        'description': description,
        'imgUrl': imgUrl,
        'toppings': List<dynamic>.from(toppings.map((x) => x.toJson())),
        'isAvaliable': isAvaliable,
        'categoryId': categoryId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'uuid': uuid,
        'note': note,
        'totalWithToppings': totalWithToppings,
      };

  @override
  List<Object?> get props {
    return [
      id,
      name,
      price,
      description,
      imgUrl,
      toppings,
      isAvaliable,
      categoryId,
      createdAt,
      uuid,
      updatedAt,
      v,
      note,
      totalWithToppings,
    ];
  }

  ProductDetailModel copyWith({
    String? id,
    String? name,
    int? price,
    String? description,
    String? imgUrl,
    List<Topping>? toppings,
    bool? isAvaliable,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? note,
    String? uuid,
    num? totalWithToppings,
  }) {
    return ProductDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
      toppings: toppings ?? this.toppings,
      isAvaliable: isAvaliable ?? this.isAvaliable,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      uuid: uuid ?? this.uuid,
      v: v ?? this.v,
      note: note ?? this.note,
      totalWithToppings: totalWithToppings ?? this.totalWithToppings,
    );
  }

  @override
  String toString() {
    return 'ProductDetailModel(id: $id, name: $name, price: $price, description: $description, imgUrl: $imgUrl, toppings: $toppings, isAvaliable: $isAvaliable, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, note: $note, totalWithToppings: $totalWithToppings, uuid: $uuid)';
  }
}

class Topping extends Equatable {
  factory Topping.fromJson(Map<String, dynamic> json) => Topping(
        id: json['_id'],
        name: json['name'],
        type: json['type'],
        options: List<Option>.from(json['options'].map((x) => Option.fromJson(x))),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        maxOptions: json['maxOptions'],
        minOptions: json['minOptions'],
      );

  const Topping({
    required this.id,
    required this.name,
    required this.type,
    required this.options,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.minOptions,
    required this.maxOptions,
  });

  final String id;
  final String name;
  final String type;
  final List<Option> options;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final int minOptions;
  final int maxOptions;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'type': type,
        'options': List<dynamic>.from(options.map((x) => x.toJson())),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'maxOptions': maxOptions,
        'minOptions': minOptions,
        '__v': v,
      };

  @override
  List<Object> get props {
    return [
      id,
      name,
      type,
      options,
      createdAt,
      updatedAt,
      v,
      minOptions,
      maxOptions,
    ];
  }

  Topping copyWith({
    String? id,
    String? name,
    String? type,
    List<Option>? options,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    int? minOptions,
    int? maxOptions,
  }) {
    return Topping(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      minOptions: minOptions ?? this.minOptions,
      maxOptions: maxOptions ?? this.maxOptions,
    );
  }

  @override
  bool get stringify => true;
}

class Option extends Equatable {
  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['_id'],
        name: json['name'],
        price: json['price'],
        imgUrl: json['imgUrl'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );
  const Option({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String name;
  final int price;
  final String imgUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'price': price,
        'imgUrl': imgUrl,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };

  @override
  List<Object?> get props => [id, name, price, imgUrl, createdAt, updatedAt, v];
}
