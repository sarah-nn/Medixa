import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/drugs/data/repositories/medicine_repository_impl.dart';
import '../../features/drugs/domain/repositories/medicine_repository.dart';
import '../../features/drugs/presentation/bloc/medicine_lookup_bloc.dart';
import '../../features/drugs/data/services/drug_assistant_service.dart';
import '../../features/drugs/presentation/bloc/drug_assistant_bloc.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/presentation/bloc/note_bloc.dart';
import '../../features/sales/data/repositories/sales_repository_impl.dart';
import '../../features/sales/domain/repositories/sales_repository.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../session/session_manager.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/shared_preferences_storage.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AuthBloc>()) return;
  final preferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<LocalStorage>(
      () => SharedPreferencesStorage(preferences),
    )
    ..registerLazySingleton(() => SecureStorage(const FlutterSecureStorage()))
    ..registerLazySingleton(() => SessionManager(sl(), sl()))
    ..registerLazySingleton(() => DioClient(sl()))
    ..registerLazySingleton<Dio>(() => sl<DioClient>().dio)
    ..registerLazySingleton(() => NetworkInfo(Connectivity()))
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<MedicineRepository>(
      () => MedicineRepositoryImpl(sl()),
    )
    ..registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl(sl()))
    ..registerLazySingleton<SalesRepository>(() => SalesRepositoryImpl(sl()))
    ..registerLazySingleton<FirebaseAI>(() => FirebaseAI.googleAI())
    ..registerLazySingleton<DrugAssistantService>(
      () => DrugAssistantService(sl(), sl(), sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerFactory(() => AuthBloc(sl(), sl(), sl()))
    ..registerFactory(() => MedicineLookupBloc(sl(), sl()))
    ..registerFactory(() => DrugAssistantBloc(sl()));
  sl.registerFactory(() => NoteBloc(sl(), sl()));
}
