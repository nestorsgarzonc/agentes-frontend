import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:diner/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_table/models/users_table.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/home/ui/widgets/table_user_card.dart';
import 'package:diner/features/payment/ui/payment_screen.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';

class TableMenuScreen extends ConsumerWidget {
  const TableMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableProv = ref.watch(tableProvider);
    final restaurantState = ref.watch(restaurantProvider);
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                restaurantState.restaurant.on(
                  onData: (data) => Text(
                    'Mesa: ${data.tableName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  onError: (err) => Center(child: Text('Error ${err.message}')),
                  onLoading: () => const Center(child: CircularProgressIndicator()),
                  onInitial: () => const SizedBox(),
                ),
                const SizedBox(height: 10),
                tableProv.tableUsers.on(
                  onData: (tableData) => Expanded(
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Lottie.asset(
                                LottieAssets.ordering,
                                width: 140,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estado',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('${tableData.tableStatus?.translatedValue}...'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    tableData.needsWaiter
                                        ? '¿Estas llamando al mesero?'
                                        : '¿Necesitas ayuda?',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: tableData.needsWaiter
                                        ? ref.read(tableProvider.notifier).stopCallingWaiter
                                        : ref.read(tableProvider.notifier).callWaiter,
                                    child: Text(
                                      tableData.needsWaiter
                                          ? 'Dejar de llamar al mesero'
                                          : 'Llamar al mesero',
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: tableData.users.length,
                          itemBuilder: (context, index) {
                            final item = tableData.users[index];
                            return TableUserCard(userTable: item, showPrice: true);
                          },
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                  onError: (_) => const SizedBox(),
                  onLoading: () => const SizedBox(),
                  onInitial: () => const SizedBox(),
                ),
              ],
            ),
          ),
          tableProv.tableUsers.on(
            onData: (data) => data.tableStatus?.actionButtonLabel == null
                ? const SizedBox()
                : Positioned(
                    bottom: 5,
                    left: 20,
                    right: 20,
                    child: canChangeStatus(data.tableStatus!, data)
                        ? CustomElevatedButton(
                            onPressed: () => handleOnOrderNow(ref, data.tableStatus!, context),
                            child: Text(data.tableStatus!.actionButtonLabel!),
                          )
                        : const SizedBox(),
                  ),
            onError: (_) => const SizedBox(),
            onLoading: () => const SizedBox(),
            onInitial: () => const SizedBox(),
          ),
        ],
      ),
    );
  }

  bool canChangeStatus(TableStatus status, UsersTable usersTable) {
    if (status != TableStatus.ordering && usersTable.totalPrice != 0) {
      return true;
    }
    return false;
  }

  void handleOnOrderNow(WidgetRef ref, TableStatus status, BuildContext context) {
    switch (status) {
      case TableStatus.empty:
        ref.read(tableProvider.notifier).changeStatus(TableStatus.eating);
        break;
      case TableStatus.ordering:
        ref.read(tableProvider.notifier).orderNow();
        break;
      case TableStatus.confirmOrder:
        ref.read(tableProvider.notifier).changeStatus(TableStatus.eating);
        break;
      case TableStatus.eating:
        ref.read(tableProvider.notifier).changeStatus(TableStatus.paying);
        break;
      case TableStatus.paying:
        GoRouter.of(context).push(PaymentScreen.route);
        break;
      case TableStatus.orderConfirmed:
        ref.read(tableProvider.notifier).changeStatus(TableStatus.paying);
        break;
    }
  }
}
