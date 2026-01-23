import 'package:audio_guide/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_guide/route/route_constants.dart';
import 'package:audio_guide/theme/app_theme.dart';
import 'package:audio_guide/route/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().init();

  runApp(
      const ProviderScope(child: MyApp())
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'APP',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: homeScreenRoute,
    );
  }
}
