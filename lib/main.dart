import 'package:flutter/material.dart';
import 'package:uniprocess_app/config/router/app_raouter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniprocess_app/config/theme/app_theme.dart';
import 'package:uniprocess_app/config/theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}
