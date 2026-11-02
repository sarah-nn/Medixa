import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart'
    show SplashPage;
import '../../features/drugs/presentation/pages/barcode_scanner_page.dart';
import '../../features/drugs/presentation/pages/drug_assistant_page.dart';
import '../../features/drugs/presentation/pages/inventory_overview_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notes/presentation/pages/notes_page.dart';

abstract final class AppRouter {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const barcodeScanner = '/barcode-scanner';
  static const drugAssistant = '/drug-assistant';
  static const inventory = '/inventory';
  static const notes = '/notes';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      login => MaterialPageRoute(
        builder: (_) => const LoginPage(),
        settings: settings,
      ),
      home => MaterialPageRoute(
        builder: (_) => const HomePage(),
        settings: settings,
      ),
      barcodeScanner => MaterialPageRoute(
        builder: (_) => const BarcodeScannerPage(),
        settings: settings,
      ),
      drugAssistant => MaterialPageRoute(
        builder: (_) => const DrugAssistantPage(),
        settings: settings,
      ),
      inventory => MaterialPageRoute(
        builder: (_) => const InventoryOverviewPage(),
        settings: settings,
      ),
      notes => MaterialPageRoute(
        builder: (_) => const NotesPage(),
        settings: settings,
      ),
      _ => MaterialPageRoute(
        builder: (_) => const SplashPage(),
        settings: settings,
      ),
    };
  }
}
