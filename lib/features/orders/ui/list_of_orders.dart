import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:oyt_front_core/utils/formatters.dart';
import 'package:diner/features/bill/ui/bill_screen.dart';
import 'package:diner/features/orders/provider/orders_provider.dart';

class ListOfOrdersScreen extends ConsumerStatefulWidget {
  const ListOfOrdersScreen({super.key});

  static const route = '/list-of-orders';

  @override
  ConsumerState<ListOfOrdersScreen> createState() => _ListOfOrdersScreenState();
}

class _ListOfOrdersScreenState extends ConsumerState<ListOfOrdersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).getOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis ordenes')),
      body: ordersState.orders.on(
        onData: (data) => data.orders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(LottieAssets.ordering, height: 200),
                  const SizedBox(width: double.infinity, height: 20),
                  const Text('Aqui veras las ordenes que has realizado...'),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: data.orders.length,
                itemBuilder: (context, index) {
                  final order = data.orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(right: 16, top: 8, bottom: 8, left: 4),
                      onTap: () => GoRouter.of(context)
                          .push('${BillScreen.route}?transactionId=${order.id}&canPop=true'),
                      horizontalTitleGap: 10,
                      leading: Image.network(order.restaurantImage, width: 80),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      title: Text(
                        order.restaurantName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text('Fecha: ${Formatters.dateFormatter(order.creationDate)}'),
                          const SizedBox(height: 1),
                          Text(
                            'Precio: \$ ${CurrencyFormatter.format(order.totalPrice)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        onError: (err) => Text(err.toString()),
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onInitial: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
