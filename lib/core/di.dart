import 'package:client/data/repositories/categories_repository.dart';
import 'package:client/presentation/providers/side_bar_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../presentation/providers/categories_provider.dart';

/// service locator
final sl = GetIt.instance;

/// Dependency injection utility
class DI {
  static Future<void> init() async {
    // sl.registerLazySingleton<ApiConnection>(
    //   () => !kDebugMode
    //       ? ApiConnection(apiConfig: ApiConfig())
    //       : ApiConnectionMock(apiConfig: ApiConfig()),
    // );
    //
    // // Repositories
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepository(),
    );

    // Providers
    sl.registerLazySingleton<SideBarProvider>(
      () => SideBarProvider(),
    );

    sl.registerLazySingleton<CategoryProvider>(
      () => CategoryProvider(sl()),
    );
    // sl.registerLazySingleton<ProductDetailProvider>(
    //   () => ProductDetailProvider(sl()),
    // );
  }
}
