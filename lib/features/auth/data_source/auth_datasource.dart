import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/constants/db_constants.dart';
import 'package:restaurants/core/external/api_handler.dart';
import 'package:restaurants/core/external/db_handler.dart';
import 'package:restaurants/core/logger/logger.dart';
import 'package:restaurants/features/auth/models/auth_model.dart';
import 'package:restaurants/features/user/models/user_model.dart';

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasourceImpl.fromRead(ref.read);
});

abstract class AuthDatasource {
  Future<AuthModel> login(String email, String password);
  Future<void> register(User user);
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<AuthModel> getUserByToken();
}

class AuthDatasourceImpl implements AuthDatasource {
  factory AuthDatasourceImpl.fromRead(Reader read) {
    final apiHandler = read(apiHandlerProvider);
    final dbHandler = read(dbHandlerProvider);
    return AuthDatasourceImpl(apiHandler, dbHandler);
  }

  const AuthDatasourceImpl(this.apiHandler, this.dbHandler);

  final ApiHandler apiHandler;
  final DBHandler dbHandler;

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

  @override
  Future<void> saveToken(String token) async {
    try {
      await dbHandler.put(DbConstants.bearerTokenKey, token, DbConstants.authBox);
      return;
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<String?> getToken() {
    try {
      return dbHandler.get(DbConstants.bearerTokenKey, DbConstants.authBox);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<AuthModel> getUserByToken() async {
    try {
      final res = await apiHandler.get('/auth/refresh-token');
      return AuthModel.fromJson(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
