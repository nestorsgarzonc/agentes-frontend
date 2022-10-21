import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/features/restaurant/provider/restaurant_provider.dart';

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
  split(title: 'Pago total'),
  all(title: 'Pago individual');

  const PaymentWay({required this.title});

  final String title;
}

enum PaymentTip {
  ten(title: '10%'),
  five(title: '5%'),
  none(title: 'Sin propina');

  const PaymentTip({required this.title});

  final String title;
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod? paymentMethod;
  PaymentWay? paymentWay;
  PaymentTip? paymentTip;

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar cuenta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Cuenta mesa ${restaurantState.restaurant.data?.tableName}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Resumen de productos:',
            style: TextStyle(fontSize: 16),
          ),
          //TODO: SHOW CARROUSEL
          const SizedBox(height: 10),
          const Text(
            'Propina:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          ...PaymentTip.values.map(
            (e) => Card(
              child: RadioListTile<PaymentTip>(
                value: e,
                title: Text(e.title),
                groupValue: paymentTip,
                onChanged: (value) => setState(() => paymentTip = value),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Selecciona la forma de pago:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
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
          const Text(
            'Selecciona el metodo de pago:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
