import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:oyt_front_order/models/pay_order_mod.dart';
import 'package:diner/features/orders/provider/orders_provider.dart';
import 'package:diner/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_table/models/users_table.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/home/ui/widgets/table_user_card.dart';
import 'package:diner/features/payment/ui/account_total_item.dart';
import 'package:diner/features/widgets/bottom_sheet/account_detail_bottom_sheet.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';
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
  all(title: 'Pago total', paymentValue: 'all'),
  split(title: 'Pago individual', paymentValue: 'split');

  const PaymentWay({required this.title, required this.paymentValue});

  final String paymentValue;
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
  PaymentMethod? paymentMethod = PaymentMethod.cash;
  PaymentWay? paymentWay = PaymentWay.all;
  PaymentTip? paymentTip = PaymentTip.ten;

  static const _titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final tableState = ref.watch(tableProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar cuenta mesa ${restaurantState.restaurant.data?.tableName}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Resumen del pedido:', style: _titleStyle),
          const SizedBox(height: 5),
          tableState.tableUsers.on(
            onData: (data) {
              return Card(
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
              );
            },
            onError: (err) => Text('$err'),
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onInitial: () => const Center(child: CircularProgressIndicator()),
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
                onTap: () => setState(() => paymentTip = PaymentTip.values[i]),
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
                onChanged: (value) => setState(() => paymentWay = value),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Selecciona el metodo de pago:', style: _titleStyle),
          const SizedBox(height: 5),
          ...PaymentMethod.values.map(
            (e) => Card(
              child: RadioListTile<PaymentMethod>(
                value: e,
                title: Text(e.title),
                groupValue: paymentMethod,
                onChanged: (value) => setState(() => paymentMethod = value),
              ),
            ),
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
                    value:
                        '\$ ${CurrencyFormatter.format(tableState.tableUsers.data?.totalPrice ?? 0)}',
                  ),
                  AccountTotalItem(
                    title: 'Propina:',
                    value: paymentTip == null
                        ? 'No seleccionado'
                        : '\$ ${CurrencyFormatter.format(paymentTip?.calculateTip(tableState.tableUsers.data?.totalPrice ?? 0) ?? 0)}',
                  ),
                  AccountTotalItem(
                    title: 'Total a pagar:',
                    isBold: true,
                    value:
                        '\$ ${CurrencyFormatter.format((paymentTip?.calculateTip(tableState.tableUsers.data?.totalPrice ?? 0) ?? 0) + (tableState.tableUsers.data?.totalPrice ?? 0))}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(onPressed: handleOnPayNow, child: const Text('Pagar ahora')),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void handleOnPayNow() {
    if (paymentMethod == null) {
      CustomSnackbar.showSnackBar(context, 'Selecciona un metodo de pago');
      return;
    }
    if (paymentWay == null) {
      CustomSnackbar.showSnackBar(context, 'Selecciona una forma de pago');
      return;
    }
    ref.read(ordersProvider.notifier).payOrder(
          PayOrderModel(
            tableId: ref.read(tableProvider).tableCode!,
            tip: paymentTip?.value ?? 0,
            paymentMethod: paymentMethod!.paymentValue,
            paymentWay: paymentWay!.paymentValue,
          ),
        );
  }

  void showAccountDetail(UsersTable usersTable) =>
      AccountDetailBottomSheet.show(context, usersTable);
}
