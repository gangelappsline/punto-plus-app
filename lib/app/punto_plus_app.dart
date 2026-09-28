import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'app_router.dart';

final class PuntoPlusApp extends StatelessWidget {
  const PuntoPlusApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Punto+',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      );
}
