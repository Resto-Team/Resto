import 'package:get_it/get_it.dart';
import 'package:resto/core/network/api_service.dart';
import 'package:resto/core/network/dio_client.dart';
import 'package:resto/features/auth/data/repos/auth_repo_impl.dart';
import 'package:resto/features/auth/domain/repositories/auth_repo.dart';
import 'package:resto/features/auth/presentation/manager/login/login_cubit.dart';
import 'package:resto/features/auth/presentation/manager/register/register_cubit.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/cart/data/repos/cart_repo_impl.dart';
import 'package:resto/features/cart/domain/repositories/cart_repo.dart';
import 'package:resto/features/cart/presentation/manager/cubit/cart_cubit.dart';
import 'package:resto/features/home/data/repos/home_repo_impl.dart';
import 'package:resto/features/home/domain/repositories/home_repo.dart';
import 'package:resto/features/home/presentation/manager/categories/categories_cubit.dart';
import 'package:resto/features/home/presentation/manager/products/products_cubit.dart';
import 'package:resto/features/order_history/data/repos/order_history_repo_impl.dart';
import 'package:resto/features/order_history/domain/repositories/order_history_repo.dart';
import 'package:resto/core/helpers/cache_helper.dart';
import 'package:resto/core/localization/manager/locale_cubit.dart';
import 'package:resto/core/theme/manager/theme_cubit.dart';
import 'package:resto/features/order_history/presentation/manager/cubit/order_history_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt()));

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  getIt.registerLazySingleton<SessionCubit>(() => SessionCubit(getIt()));

  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(getIt()));
  getIt.registerFactory<ProductsCubit>(() => ProductsCubit(getIt()));
  getIt.registerFactory<CategoriesCubit>(() => CategoriesCubit(getIt()));

  getIt.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(cartRepo: getIt<CartRepo>()),
  );

  getIt.registerLazySingleton<OrderHistoryRepo>(
    () => OrderHistoryRepoImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<OrderHistoryCubit>(
    () => OrderHistoryCubit(orderHistoryRepo: getIt<OrderHistoryRepo>()),
  );

  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(cacheHelper: getIt<CacheHelper>()),
  );
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(cacheHelper: getIt<CacheHelper>()),
  );
}
