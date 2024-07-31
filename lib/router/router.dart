import 'package:expense_tracker/features/analytics/analitics.dart';
import 'package:expense_tracker/features/asset/asset_page.dart';
import 'package:expense_tracker/features/calendar/calendar_page.dart';
import 'package:expense_tracker/features/dashboard/homepage.dart';
import 'package:expense_tracker/shared/views/root_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _pageKey = ValueKey("_pageKey");
const _scaffoldKey = ValueKey("_scaffoldKey");

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

final appRouter = GoRouter(routes: [
  GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(
          key: _pageKey,
          child: RootLayout(
              key: _scaffoldKey, currentIndex: 0, child: Homepage()))),
  GoRoute(
      path: '/calendar',
      pageBuilder: (context, state) => const MaterialPage(
          key: _pageKey,
          child: RootLayout(
              key: _scaffoldKey, currentIndex: 1, child: CalendarPage()))),
  GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) => const MaterialPage(
          key: _pageKey,
          child: RootLayout(
              key: _scaffoldKey, currentIndex: 2, child: AnaliticsPage()))),
  GoRoute(
      path: '/asset',
      pageBuilder: (context, state) => const MaterialPage(
          key: _pageKey,
          child: RootLayout(
              key: _scaffoldKey, currentIndex: 3, child: AssetPage()))),
]);
