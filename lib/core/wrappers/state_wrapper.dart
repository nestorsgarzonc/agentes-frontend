import 'package:equatable/equatable.dart';
import 'package:restaurants/core/failure/failure.dart';

enum States { loading, initial, error, success }

class StateAsync<T> extends Equatable {
  const StateAsync(
    this._state, [
    this._data,
    this._error,
  ]);

  factory StateAsync.loading() => const StateAsync(States.loading);

  factory StateAsync.initial() => const StateAsync(States.initial);

  factory StateAsync.success(T data) => StateAsync(States.success, data);

  factory StateAsync.error(Failure error) => StateAsync(States.error, null, error);
  final States _state;
  final T? _data;
  final Failure? _error;

  States get state => _state;
  T? get data => _data;
  Failure? get error => _error;

  W on<W>({
    required W Function(T) onData,
    required W Function(Failure) onError,
    required W Function() onLoading,
    required W Function() onInitial,
  }) {
    switch (_state) {
      case States.loading:
        return onLoading();
      case States.initial:
        return onInitial();
      case States.success:
        return onData(_data as T);
      case States.error:
        return onError(_error!);
    }
  }

  W onMayNull<W>({
    required W Function(T?) onData,
    required W Function(Failure) onError,
    required W Function() onLoading,
    required W Function() onInitial,
  }) {
    switch (_state) {
      case States.loading:
        return onLoading();
      case States.initial:
        return onInitial();
      case States.success:
        return onData(_data);
      case States.error:
        return onError(_error!);
    }
  }

  @override
  List<Object?> get props => [_state, _data, _error];
}
