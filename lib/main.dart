import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:new_my_app/data/services/shared_preferences_service.dart';
import 'package:new_my_app/navigation/router.dart';
import 'package:new_my_app/utils/create_text_theme.dart';
import 'package:provider/provider.dart';
import 'package:new_my_app/config/dependencies.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  Logger.root.level = Level.ALL;

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesService().saveToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ0ODEwODQ3LCJpYXQiOjE3NDQyMDYwNDcsImp0aSI6ImMwOTdiMjQxOWFiYTRhOWNhZmI3NThlODE5MzUwNWE1IiwidXNlcl9pZCI6IjZkNDc1NDg0LWM1ZDYtNDkyZC05OGM3LTI3YjA3MzM4MDZiMSJ9.5rbz-kYzy3HiSs-VizQd38L21oIbxyNWJM0NXgkgYKE');
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = createTextTheme(context, 'Inter', 'Inter');
    return MaterialApp.router(
      theme: ThemeData(
        // platform: TargetPlatform.iOS,
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routerConfig: router,
      
    );
  }
}
