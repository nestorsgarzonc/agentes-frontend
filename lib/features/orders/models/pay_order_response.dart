import 'dart:convert';

import 'package:equatable/equatable.dart';

class PayOrderResponse extends Equatable {
  const PayOrderResponse({
    required this.id,
  });

  factory PayOrderResponse.fromMap(Map<String, dynamic> map) {
    return PayOrderResponse(
      id: map['order']['_id'] ?? '',
    );
  }

  factory PayOrderResponse.fromJson(String source) => PayOrderResponse.fromMap(json.decode(source));

  final String id;

  PayOrderResponse copyWith({
    String? id,
  }) {
    return PayOrderResponse(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'CreateOrderResponse(id: $id)';

  @override
  List<Object> get props => [id];
}
