import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../data/repositories/cat_repository.dart';
import '../presentation/provider/cat_notifier.dart';

final locator = GetIt.instance;

void init() {
  // notifier
  locator.registerLazySingleton<CatNotifier>(() => CatNotifier(locator()));
  // repository
  locator.registerLazySingleton<CatRepository>(() => CatRepository(locator()));
  // external i.e. http client
  locator.registerLazySingleton<Client>(() => Client());
}