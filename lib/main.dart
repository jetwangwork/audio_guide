import 'package:audio_guide/riverpod/local_notifier.dart';
import 'package:audio_guide/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_guide/route/route_constants.dart';
import 'package:audio_guide/theme/app_theme.dart';
import 'package:audio_guide/route/router.dart' as router;

import 'generated/l10n.dart';

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
    final notifier = ref.watch(localNotifier);
    return MaterialApp(
      title: 'APP',
      locale: notifier.locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: homeScreenRoute,
    );
  }
}
