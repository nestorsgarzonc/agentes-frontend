import 'package:diner/features/auth/provider/auth_provider.dart';
import 'package:diner/features/auth/provider/auth_state.dart';
import 'package:diner/features/payment/provider/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:oyt_front_order/models/pay_order_mod.dart';
import 'package:diner/features/orders/provider/orders_provider.dart';
import 'package:diner/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_table/models/users_table.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/home/ui/widgets/table_user_card.dart';
import 'package:diner/features/payment/ui/account_total_item.dart';
import 'package:diner/features/widgets/bottom_sheet/account_detail_bottom_sheet.dart';
import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  static const route = '/payment';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

enum PaymentMethod {
  cash(title: 'Efectivo', paymentValue: 'cash'),
  card(title: 'Tarjeta credito', paymentValue: 'card'),
  pse(title: 'PSE', paymentValue: 'pse');

  const PaymentMethod({required this.title, required this.paymentValue});

  final String title;
  final String paymentValue;
}

enum PaymentWay {
  all(title: 'Pago total', paymentValue: 'all', paymentLabel: 'Pagar ahora'),
  split(title: 'Pago individual', paymentValue: 'split', paymentLabel: 'Ir al pago individual');

  const PaymentWay({required this.title, required this.paymentValue, required this.paymentLabel});

  final String paymentValue;
  final String title;
  final String paymentLabel;
}

enum IndividualPaymentMethod {
  same(title: 'Igual monto', method: 'same'),
  respective(title: 'Monto ordenado', method: 'respective');

  const IndividualPaymentMethod({required this.title, required this.method});

  final String method;
  final String title;
}

enum PaymentTip {
  fiveteen(title: '15%', value: 15),
  ten(title: '10%', value: 10),
  five(title: '5%', value: 5),
  none(title: 'Sin propina', value: 0);

  const PaymentTip({required this.title, required this.value});

  num calculateTip(num total) => total * (value / 100);

  final String title;
  final int value;
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  static const _titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  PaymentMethod paymentMethod = PaymentMethod.cash;
  PaymentWay paymentWay = PaymentWay.all;
  PaymentTip paymentTip = PaymentTip.ten;
  IndividualPaymentMethod individualPaymentMethod = IndividualPaymentMethod.same;
  num subtotal = 0;
  num total = 0;
  num tip = 0;
  bool canCalculateOnInitial = true;

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final tableState = ref.watch(tableProvider);
    final userState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar cuenta mesa ${restaurantState.restaurant.data?.tableName}'),
      ),
      body: tableState.tableUsers.on(
        onError: (err) => Text('$err'),
        onLoading: () => const LoadingWidget(),
        onInitial: () => const LoadingWidget(),
        onData: (data) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (canCalculateOnInitial) {
              canCalculateOnInitial = false;
              _calculateTotals(data, userState);
            }
          });
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Resumen del pedido:', style: _titleStyle),
              const SizedBox(height: 5),
              Card(
                child: Column(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.all(0),
                      separatorBuilder: (context, index) => const Divider(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: data.users.length,
                      itemBuilder: (context, index) => TableUserCard(
                        userTable: data.users[index],
                        isExpanded: false,
                        showPrice: true,
                      ),
                    ),
                    TextButton(
                      onPressed: () => showAccountDetail(data),
                      child: const Text('Ver detalle de la cuenta'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text('Selecciona la propina:', style: _titleStyle),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: PaymentTip.values.length,
                  itemBuilder: (context, i) => InkWell(
                    child: Chip(
                      label: Text(
                        PaymentTip.values[i].title,
                        style: TextStyle(
                          color: paymentTip == PaymentTip.values[i] ? Colors.white : Colors.black,
                        ),
                      ),
                      backgroundColor: paymentTip == PaymentTip.values[i]
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                    onTap: () {
                      paymentTip = PaymentTip.values[i];
                      _calculateTotals(data, userState);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Selecciona la forma de pago:', style: _titleStyle),
              const SizedBox(height: 5),
              ...PaymentWay.values.map(
                (e) => Card(
                  child: RadioListTile<PaymentWay>(
                    value: e,
                    title: Text(e.title),
                    groupValue: paymentWay,
                    onChanged: (value) {
                      if (value == null) return;
                      paymentWay = value;
                      _calculateTotals(data, userState);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              paymentWay == PaymentWay.all
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selecciona el metodo de pago:', style: _titleStyle),
                        const SizedBox(height: 5),
                        ...PaymentMethod.values.map(
                          (e) => Card(
                            child: RadioListTile<PaymentMethod>(
                              value: e,
                              title: Text(e.title),
                              groupValue: paymentMethod,
                              onChanged: (value) {
                                if (value == null) return;
                                paymentMethod = value;
                                _calculateTotals(data, userState);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selecciona la forma de pago individual:', style: _titleStyle),
                        const SizedBox(height: 5),
                        ...IndividualPaymentMethod.values.map(
                          (e) => Card(
                            child: RadioListTile<IndividualPaymentMethod>(
                              value: e,
                              title: Text(e.title),
                              groupValue: individualPaymentMethod,
                              onChanged: (value) {
                                if (value == null) return;
                                individualPaymentMethod = value;
                                _calculateTotals(data, userState);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              const Text('Resumen de cuenta:', style: _titleStyle),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AccountTotalItem(
                        title: 'Subtotal:',
                        value: '\$ ${CurrencyFormatter.format(subtotal)}',
                      ),
                      AccountTotalItem(
                        title: 'Propina:',
                        value: '\$ ${CurrencyFormatter.format(paymentTip.calculateTip(subtotal))}',
                      ),
                      AccountTotalItem(
                        title: 'Total a pagar:',
                        isBold: true,
                        value: '\$ ${CurrencyFormatter.format(total)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: handleOnPayNow,
                child: Text(paymentWay.paymentLabel),
              ),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }

  void _calculateTotals(UsersTable usersTable, AuthState userState) {
    _calculateSubtotal(usersTable, userState);
    tip = paymentTip.calculateTip(subtotal);
    total = subtotal + tip;
    if (mounted) setState(() {});
  }

  void _calculateSubtotal(UsersTable usersTable, AuthState userState) {
    final totalPrice = usersTable.totalPrice ?? 0;
    final usersConnected = usersTable.users;
    Logger.log('### CALCULATE SUBTOTAL ###');
    Logger.log('PaymentWay: $paymentWay');
    Logger.log('IndividualPaymentMethod: $individualPaymentMethod');
    Logger.log('Subtotal before: $subtotal');
    Logger.log('Total price: $totalPrice');
    Logger.log('Users: $usersConnected');
    Logger.log('# Users: ${usersConnected.length}');
    subtotal = 0;
    switch (paymentWay) {
      case PaymentWay.all:
        subtotal = totalPrice;
        break;
      case PaymentWay.split:
        switch (individualPaymentMethod) {
          case IndividualPaymentMethod.same:
            subtotal = totalPrice / usersConnected.length;
            break;
          case IndividualPaymentMethod.respective:
            final user =
                usersConnected.firstWhere((e) => e.userId == userState.authModel.data?.user.id);
            subtotal = user.price;
            break;
        }
        break;
    }
    Logger.log('Subtotal after: $subtotal');
    Logger.log('### END CALCULATE SUBTOTAL ###');
  }

  void handleOnPayNow() {
    switch (paymentWay) {
      case PaymentWay.all:
        ref
            .read(paymentProvider.notifier)
            .askAccount(paymentWay.paymentValue, paymentMethod.paymentValue, tip);
        break;
      case PaymentWay.split:
        ref.read(paymentProvider.notifier).payAccountSingle(
              paymentWay.paymentValue,
              paymentMethod.paymentValue,
              individualPaymentMethod.method,
            );
        break;
      default:
        CustomSnackbar.showSnackBar(context, 'No fue posible realizar el pago');
        break;
    }
    ref.read(ordersProvider.notifier).payOrder(
          PayOrderModel(
            tableId: ref.read(tableProvider).tableId!,
            tip: paymentTip.value,
            paymentMethod: paymentMethod.paymentValue,
            paymentWay: paymentWay.paymentValue,
          ),
        );
  }

  void showAccountDetail(UsersTable usersTable) =>
      AccountDetailBottomSheet.show(context, usersTable);
}
