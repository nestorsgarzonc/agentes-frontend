import 'dart:convert';

import 'package:equatable/equatable.dart';

class ConnectSocket extends Equatable {
  const ConnectSocket({required this.tableId, required this.token});

  factory ConnectSocket.fromMap(Map<String, dynamic> map) {
    return ConnectSocket(
      tableId: map['tableId'] ?? '',
      token: map['token'] ?? '',
    );
  }
  factory ConnectSocket.fromJson(String source) => ConnectSocket.fromMap(json.decode(source));

  final String tableId;
  final String token;

  @override
  List<Object?> get props => [tableId, token];

  Map<String, dynamic> toMap() {
    return {
      'tableId': tableId,
      'token': token,
    };
  }

  String toJson() => json.encode(toMap());
}
