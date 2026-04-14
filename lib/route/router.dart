import 'package:flutter/material.dart';
import 'screen_export.dart';
import 'package:audio_guide/route/route_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

    case playerScreenRoute:
      final args = settings.arguments as PlayerScreenArgs;
      return MaterialPageRoute(
        builder: (context) => PlayerPage(id: args.id, title: args.title),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  }
}
