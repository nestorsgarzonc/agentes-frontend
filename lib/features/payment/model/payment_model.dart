import 'package:equatable/equatable.dart';

class Payment extends Equatable {

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentWay: map['paymentWay'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      tip: map['tip'] ?? '',
      tableId: map['tableId'] ?? '',
    );
  }

  const Payment({
    required this.paymentWay,
    required this.paymentMethod,
    required this.tip,
    required this.tableId,
  });
  final String paymentWay;
  final String paymentMethod;
  final num tip;
  final String tableId;
  
  @override
  List<Object?> get props {
    return [
      paymentWay,
      paymentMethod,
      tip,
      tableId,
    ];
  }

}