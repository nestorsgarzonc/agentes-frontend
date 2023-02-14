import 'package:diner/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:oyt_front_table/widgets/table_status_card.dart';
import 'package:oyt_front_table/widgets/call_to_waiter_card.dart';
import 'package:oyt_front_widgets/dialogs/confirm_action_dialog.dart';
import 'package:oyt_front_widgets/loading/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:diner/features/restaurant/provider/restaurant_provider.dart';
import 'package:oyt_front_table/models/users_table.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/home/ui/widgets/table_user_card.dart';
import 'package:diner/features/payment/ui/payment_screen.dart';

import 'package:oyt_front_widgets/widgets/snackbar/custom_snackbar.dart';

class TableMenuScreen extends ConsumerWidget {
  const TableMenuScreen({super.key});
  //ignore this comment

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
                  onData: (data) => Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Mesa: ${data.tableName}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ),
                      tableProv.tableUsers.on(
                        onData: (data) => data.tableStatus == TableStatus.ordering
                            ? ElevatedButton.icon(
                                onPressed: () => _onLeaveTable(ref, context),
                                label: const Text('Salir de la mesa'),
                                icon: const Icon(Icons.exit_to_app),
                              )
                            : const SizedBox.shrink(),
                        onError: (_) => const SizedBox.shrink(),
                        onLoading: () => const SizedBox.shrink(),
                        onInitial: () => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  onError: (err) => Center(child: Text('Error ${err.message}')),
                  onLoading: () => const LoadingWidget(),
                  onInitial: () => const LoadingWidget(),
                ),
                const SizedBox(height: 10),
                tableProv.tableUsers.on(
                  onData: (tableData) => Expanded(
                    child: ListView(
                      children: [
                        TableStatusCard(tableStatus: tableData.tableStatus),
                        const SizedBox(height: 10),
                        CallToWaiterCard(
                          needWaiter: tableData.needsWaiter,
                          onCallWaiter: (isCalling) => isCalling
                              ? ref.read(tableProvider.notifier).stopCallingWaiter()
                              : ref.read(tableProvider.notifier).callWaiter(),
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
                  onError: (error) => Center(child: Text('Error $error')),
                  onLoading: () => const LoadingWidget(),
                  onInitial: () => const LoadingWidget(),
                ),
              ],
            ),
          ),
          tableProv.tableUsers.on(
            onData: (data) => _canChangeStatus(data.tableStatus, data)
                ? Positioned(
                    bottom: 5,
                    left: 20,
                    right: 20,
                    child: FilledButton(
                      onPressed: () => handleOnOrderNow(ref, data.tableStatus!, context),
                      child: Text(data.tableStatus!.actionButtonLabel!),
                    ),
                  )
                : const SizedBox(),
            onError: (error) => Center(child: Text('Error $error')),
            onLoading: () => const LoadingWidget(),
            onInitial: () => const LoadingWidget(),
          ),
        ],
      ),
    );
  }

  void _onLeaveTable(WidgetRef ref, BuildContext context) {
    ConfirmActionDialog.show(
      context: context,
      onConfirm: () {
        ref
            .read(authProvider.notifier)
            .logout(withLeaveTable: true, logoutMessage: 'Gracias por usar On Your Table');
        Navigator.of(context).pop();
      },
      title: '¿Estás seguro?',
      subtitle: 'Si sales de la mesa, perderas los productos agregados.',
    );
  }

  bool _canChangeStatus(TableStatus? status, UsersTable usersTable) =>
      usersTable.hasSomeProducts &&
      !usersTable.isTableEmpty &&
      usersTable.totalPrice != 0 &&
      status?.actionButtonLabel != null;

  void handleOnOrderNow(WidgetRef ref, TableStatus? status, BuildContext context) {
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
      default:
        CustomSnackbar.showSnackBar(context, 'No se puede cambiar el estado de la mesa');
        break;
    }
  }
}
