import 'package:equatable/equatable.dart';

import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/table/models/users_table.dart';

class TableState extends Equatable {
  const TableState({required this.tableUsers, this.tableCode, this.isFirstTime = true});

  final String? tableCode;
  final StateAsync<UsersTable> tableUsers;
  final bool isFirstTime;

  @override
  List<Object?> get props => [tableCode, tableUsers, isFirstTime];

  TableState copyWith({
    String? tableCode,
    StateAsync<UsersTable>? tableUsers,
    bool? isFirstTime,
  }) {
    return TableState(
      tableCode: tableCode ?? this.tableCode,
      tableUsers: tableUsers ?? this.tableUsers,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}
