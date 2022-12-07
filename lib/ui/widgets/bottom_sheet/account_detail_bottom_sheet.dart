import 'package:flutter/material.dart';
import 'package:restaurants/features/table/models/users_table.dart';
import 'package:restaurants/ui/menu/widgets/table_user_card.dart';
import 'package:oyt_front_widgets/widgets/bottom_sheet/base_bottom_sheet.dart';

class AccountDetailBottomSheet extends StatelessWidget {
  const AccountDetailBottomSheet({super.key, required this.usersTable});
  final UsersTable usersTable;

  static void show(BuildContext context, UsersTable usersTable) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AccountDetailBottomSheet(usersTable: usersTable),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: ListView(
        children: [
          const Text(
            'Detalle de la cuenta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            primary: false,
            itemCount: usersTable.users.length,
            itemBuilder: (context, index) {
              final item = usersTable.users[index];
              return TableUserCard(userTable: item, showPrice: true, canEdit: false);
            },
          ),
          SizedBox(height: 30 + MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
