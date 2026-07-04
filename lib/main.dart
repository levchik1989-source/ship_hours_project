import 'package:flutter/material.dart';

import 'app/app_bootstrap.dart';
import 'app/ship_hours_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppBootstrap().initialize();

  runApp(
    ShipHoursApp(
      dependencies: dependencies,
    ),
  );
}
