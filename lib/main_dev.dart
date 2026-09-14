import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/resources/app_config.dart';
import 'common/utils/riverpod_logger.dart';
import 'flavor_config.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(appFlavor: Flavor.development);
  await AppConfiguration.ensureAppConfiguration();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(observers: [RiverpodLogger()], child: const MyApp()));
}
