import 'package:equatable/equatable.dart';

class TableState extends Equatable {
  const TableState({this.tableCode});

  final String? tableCode;

  @override
  List<Object?> get props => [tableCode];

  TableState copyWith({String? tableCode}) {
    return TableState(
      tableCode: tableCode ?? this.tableCode,
    );
  }
}
