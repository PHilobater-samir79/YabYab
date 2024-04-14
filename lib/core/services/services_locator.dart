import 'package:get_it/get_it.dart';
import 'package:yabyab_app/core/local_data/catch_helper.dart';
final getIt = GetIt.instance;
 Future<void> setup()  async {
   getIt.registerLazySingleton<CacheHelper>(() => CacheHelper() );
 }