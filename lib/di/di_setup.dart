import 'package:get_it/get_it.dart';

import '../service/sentry_service.dart';

GetIt getIt = GetIt.instance;

// Register your dependencies here
Future<void> configureDependencies() async {
  getIt.registerSingleton<SentryService>(SentryService());
}
