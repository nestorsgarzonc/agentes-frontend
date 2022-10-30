import 'dart:convert';
import 'package:equatable/equatable.dart';

class PayOrderModel extends Equatable {
  const PayOrderModel({
    required this.tableId,
    required this.tip,
    required this.paymentMethod,
    required this.paymentWay,
  });

  factory PayOrderModel.fromMap(Map<String, dynamic> map) {
    return PayOrderModel(
      tableId: map['tableId'] ?? '',
      tip: map['tip']?.toInt() ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      paymentWay: map['paymentWay'] ?? '',
    );
  }

  factory PayOrderModel.fromJson(String source) => PayOrderModel.fromMap(json.decode(source));

  final String tableId;
  final int tip;
  final String paymentMethod;
  final String paymentWay;

  PayOrderModel copyWith({
    String? tableId,
    int? tip,
    String? paymentMethod,
    String? paymentWay,
  }) {
    return PayOrderModel(
      tableId: tableId ?? this.tableId,
      tip: tip ?? this.tip,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentWay: paymentWay ?? this.paymentWay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tableId': tableId,
      'tip': tip,
      'paymentMethod': paymentMethod,
      'paymentWay': paymentWay,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CreateOrderModel(tableId: $tableId, tip: $tip, paymentMethod: $paymentMethod, paymentWay: $paymentWay)';
  }

  @override
  List<Object> get props => [tableId, tip, paymentMethod, paymentWay];
}
