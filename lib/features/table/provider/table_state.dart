import 'package:equatable/equatable.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_table/models/users_table.dart';

class TableState extends Equatable {
  const TableState({
    required this.tableUsers,
    this.tableId,
    this.restaurantId,
    this.isFirstTime = true,
  });

  final String? tableId;
  final String? restaurantId;
  final StateAsync<UsersTable> tableUsers;
  final bool isFirstTime;

  @override
  List<Object?> get props => [tableId, restaurantId, tableUsers, isFirstTime];

  TableState copyWith({
    String? tableId,
    String? restaurantId,
    StateAsync<UsersTable>? tableUsers,
    bool? isFirstTime,
  }) {
    return TableState(
      tableId: tableId ?? this.tableId,
      restaurantId: restaurantId ?? this.restaurantId,
      tableUsers: tableUsers ?? this.tableUsers,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}
