import 'package:diner/features/payment/model/payment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';

class PaymentState extends Equatable {

  const PaymentState({required this.payment});

  factory PaymentState.initial() {
    return PaymentState(payment: StateAsync.initial());
  }

  final StateAsync<Payment> payment;

  @override
  List<Object?> get props => [payment];

  PaymentState copyWith({
    StateAsync<Payment>? payment,
  }) {
    return PaymentState(
      payment: payment ?? this.payment,
    );
  }
}