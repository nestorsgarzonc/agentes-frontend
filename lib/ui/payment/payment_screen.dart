import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/utils/currency_formatter.dart';
import 'package:restaurants/features/restaurant/provider/restaurant_provider.dart';
import 'package:restaurants/features/table/models/users_table.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/menu/widgets/table_user_card.dart';
import 'package:restaurants/ui/widgets/bottom_sheet/account_detail_bottom_sheet.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  static const route = '/payment';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

enum PaymentMethod {
  cash(title: 'Efectivo'),
  card(title: 'Tarjeta credito'),
  pse(title: 'PSE');

  const PaymentMethod({required this.title});

  final String title;
}

enum PaymentWay {
  all(title: 'Pago total'),
  split(title: 'Pago individual');

  const PaymentWay({required this.title});

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
  PaymentMethod? paymentMethod;
  PaymentWay? paymentWay = PaymentWay.all;
  PaymentTip? paymentTip;

  static const _titleStyle = TextStyle(fontSize: 18);

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
                  label: Text(PaymentTip.values[i].title),
                  backgroundColor: paymentTip == PaymentTip.values[i]
                      ? Theme.of(context).primaryColor.withOpacity(0.8)
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
                    title: 'Subtotal',
                    value:
                        '\$ ${CurrencyFormatter.format(tableState.tableUsers.data?.totalPrice ?? 0)}',
                  ),
                  AccountTotalItem(
                    title: 'Propina',
                    value: paymentTip == null
                        ? 'No seleccionado'
                        : '\$ ${CurrencyFormatter.format(paymentTip?.calculateTip(tableState.tableUsers.data?.totalPrice ?? 0) ?? 0)}',
                  ),
                  AccountTotalItem(
                    title: 'Total a pagar',
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

  void handleOnPayNow() {}

  void showAccountDetail(UsersTable usersTable) =>
      AccountDetailBottomSheet.show(context, usersTable);
}

class AccountTotalItem extends StatelessWidget {
  const AccountTotalItem({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
  });

  final String title;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
