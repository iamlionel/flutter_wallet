import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routing/router.dart';
import '../ui/core/localization/applocalization.dart';
import '../ui/core/themes/themes.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      routerConfig: router,
    );
  }
}
