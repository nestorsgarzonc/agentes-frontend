import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/db_constants.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/external/db_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:restaurants/features/auth/models/auth_model.dart';
import 'package:restaurants/features/user/models/user_model.dart';

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasourceImpl.fromRead(ref);
});

abstract class AuthDatasource {
  Future<AuthModel> login(String email, String password);
  Future<void> register(User user);
  Future<void> logout();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  Future<String?> getToken();
  Future<AuthModel> getUserByToken();
}

class AuthDatasourceImpl implements AuthDatasource {
  factory AuthDatasourceImpl.fromRead(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    final dbHandler = ref.read(dbHandlerProvider);
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
  Future<void> logout() async {
    try {
      await apiHandler.post(
        '/auth/logout',
        {},
      );
      await deleteToken();
      return;
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

  Future<void> restorePassword(String email) async {
    try {
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

  @override
  Future<void> deleteToken() async {
    try {
      return dbHandler.delete(DbConstants.bearerTokenKey, DbConstants.authBox);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
    }
  }
}
