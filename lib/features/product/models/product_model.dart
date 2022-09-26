class ProductDetailModel {

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
        id: json['_id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        imgUrl: json['imgUrl'],
        toppings: List<Topping>.from(json['toppings'].map((x) => Topping.fromJson(x))),
        isAvaliable: json['isAvaliable'],
        categoryId: json['categoryId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );
  ProductDetailModel({
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
  });

  String id;
  String name;
  int price;
  String description;
  String imgUrl;
  List<Topping> toppings;
  bool isAvaliable;
  String categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

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
      };
}

class Topping {

  factory Topping.fromJson(Map<String, dynamic> json) => Topping(
        id: json['_id'],
        name: json['name'],
        type: json['type'],
        options: List<Option>.from(json['options'].map((x) => Option.fromJson(x))),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );
  Topping({
    required this.id,
    required this.name,
    required this.type,
    required this.options,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String name;
  String type;
  List<Option> options;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'type': type,
        'options': List<dynamic>.from(options.map((x) => x.toJson())),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

class Option {

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['_id'],
        name: json['name'],
        price: json['price'],
        imgUrl: json['imgUrl'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );
  Option({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String name;
  int price;
  String imgUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'price': price,
        'imgUrl': imgUrl,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

