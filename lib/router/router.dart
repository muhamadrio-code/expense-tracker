import 'package:expense_tracker/features/analytics/analitics.dart';
import 'package:expense_tracker/features/asset/asset_page.dart';
import 'package:expense_tracker/features/calendar/calendar_page.dart';
import 'package:expense_tracker/features/dashboard/homepage.dart';
import 'package:expense_tracker/shared/views/root_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _pageKey = ValueKey("_pageKey");
final _rootNavigationKey = GlobalKey<NavigatorState>();

const List<Destination> destinations = [
  Destination(icon: Icon(Icons.home), label: "Home", route: "/"),
  Destination(
      icon: Icon(Icons.calendar_month), label: "Calendar", route: "/calendar"),
  Destination(
      icon: Icon(Icons.analytics), label: "Analitics", route: "/analytics"),
  Destination(icon: Icon(Icons.attach_money), label: "Asset", route: "/asset"),
];

class Destination {
  const Destination(
      {required this.icon,
      required this.label,
      required this.route,
      this.child});

  final Widget icon;
  final String label;
  final String route;
  final Widget? child;
}

final appRouter =
    GoRouter(navigatorKey: _rootNavigationKey, initialLocation: '/', routes: [
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RootLayout(
            navigationShell: navigationShell,
          ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const MaterialPage(key: _pageKey, child: Homepage()),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) =>
                const MaterialPage(key: _pageKey, child: AnaliticsPage()),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) =>
                const MaterialPage(key: _pageKey, child: CalendarPage()),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/asset',
            pageBuilder: (context, state) =>
                const MaterialPage(key: _pageKey, child: AssetPage()),
          ),
        ]),
      ])
]);
