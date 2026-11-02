import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/session/session_data.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(email: email, password: password);
      await _local.saveSession(
        SessionData(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          expiresAt: response.expiresAt,
          userId: response.user.id,
          userEmail: response.user.email,
          userName: response.user.name,
          userRole: response.user.role,
        ),
      );
      return Right(response.user.toEntity());
    } catch (error) {
      return Left(ErrorHandler.map(error));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
      await _local.clearSession();
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.map(error));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await _remote.getCurrentUser();
      return Right(user.toEntity());
    } on UnauthorizedException {
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.map(error));
    }
  }
}
