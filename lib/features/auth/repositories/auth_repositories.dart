import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/external/api_exception.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:restaurants/features/auth/data_source/auth_datasource.dart';
import 'package:restaurants/features/auth/models/auth_model.dart';
import 'package:restaurants/features/user/models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl.fromRead(ref);
});

abstract class AuthRepository {
  Future<Either<Failure, AuthModel>> login(String email, String password);
  Future<Failure?> register(User user);
  Future<Failure?> logout();
  Future<Failure?> restorePassword(String email);
  Future<Either<Failure, AuthModel?>> getUserByToken();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDatasource});

  factory AuthRepositoryImpl.fromRead(Ref ref) {
    final authDatasource = ref.read(authDatasourceProvider);
    return AuthRepositoryImpl(authDatasource: authDatasource);
  }

  final AuthDatasource authDatasource;

  @override
  Future<Either<Failure, AuthModel>> login(String email, String password) async {
    try {
      final res = await authDatasource.login(email, password);
      await authDatasource.saveToken(res.bearerToken);
      return Right(res);
    } on ApiException catch (e) {
      return Left(Failure(e.response.responseMap.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Failure?> restorePassword(String email) async {
    return null;
  }

  @override
  Future<Failure?> register(User user) async {
    try {
      await authDatasource.register(user);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Failure?> logout() async {
    try {
      await authDatasource.logout();
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Either<Failure, AuthModel?>> getUserByToken() async {
    try {
      final token = await authDatasource.getToken();
      if (token == null) return const Right(null);
      final res = await authDatasource.getUserByToken();
      await authDatasource.saveToken(res.bearerToken);
      return Right(res);
    } catch (e) {
      await authDatasource.deleteToken();
      return Left(Failure(e.toString()));
    }
  }
}
