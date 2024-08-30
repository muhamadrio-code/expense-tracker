import 'package:expense_tracker/features/add_transaction/views/add_transaction_page.dart';
import 'package:expense_tracker/features/add_transaction/repositories/add_transaction_repository.dart';
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
  GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
            key: _pageKey,
            child: RootLayout(
              body: const Homepage(),
              pageIndex: 0,
              floatingActionButton: FloatingActionButton(
                onPressed: () => context.goNamed("add-todo"),
                child: const Icon(Icons.add),
              ),
            ),
          ),
      routes: [
        GoRoute(
          path: "add-todo",
          name: "add-todo",
          pageBuilder: (context, state) {
            final repo = AddTransactionRepository();
            return MaterialPage(
              child: AddTransactionPage(repository: repo),
            );
          },
        )
      ]),
  GoRoute(
    path: '/calendar',
    pageBuilder: (context, state) => MaterialPage(
      key: _pageKey,
      child: RootLayout(
        body: const CalendarPage(),
        pageIndex: 1,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.calendar_month_outlined),
        ),
      ),
    ),
  ),
  GoRoute(
    path: '/analytics',
    pageBuilder: (context, state) => MaterialPage(
      key: _pageKey,
      child: RootLayout(
        body: const AnaliticsPage(),
        pageIndex: 2,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.analytics),
        ),
      ),
    ),
  ),
  GoRoute(
    path: '/asset',
    pageBuilder: (context, state) => MaterialPage(
      key: _pageKey,
      child: RootLayout(
        body: const AssetPage(),
        pageIndex: 3,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.assessment),
        ),
      ),
    ),
  ),
]);
