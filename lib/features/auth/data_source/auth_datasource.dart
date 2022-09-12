import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/external/api_handler.dart';
import 'package:restaurants/core/logger/logger.dart';
import 'package:restaurants/features/auth/models/auth_model.dart';
import 'package:restaurants/features/user/models/user_model.dart';

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasourceImpl.fromRead(ref.read);
});

abstract class AuthDatasource {
  Future<AuthModel> login(String email, String password);
  Future<void> register(User user);
}

class AuthDatasourceImpl implements AuthDatasource {
  factory AuthDatasourceImpl.fromRead(Reader read) {
    final apiHandler = read(apiHandlerProvider);
    return AuthDatasourceImpl(apiHandler);
  }

  const AuthDatasourceImpl(this.apiHandler);

  final ApiHandler apiHandler;
  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final res = await apiHandler.post(
        '/auth/login',
        {'email': email, 'password': password},
      );
      return AuthModel.fromJson(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<void> register(User user) async {
    try {
      await apiHandler.post(
        '/auth/register',
        user.toMap(),
      );
      return;
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
