import 'dart:convert';
import 'package:oyt_front_auth/models/connect_socket.dart';
import 'package:restaurants/features/table/models/users_table.dart';

class ChangeTableStatus extends ConnectSocket {
  const ChangeTableStatus({required this.status, required super.tableId, required super.token});

  final TableStatus status;

  @override
  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'tableId': tableId,
      'token': token,
    };
  }

  @override
  String toJson() => json.encode(toMap());
}
