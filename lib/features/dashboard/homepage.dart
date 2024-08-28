import 'package:expense_tracker/features/dashboard/analytics_card.dart';
import 'package:expense_tracker/features/dashboard/expense_card.dart';
import 'package:expense_tracker/features/dashboard/sliver_sticky_expense_list.dart';
import 'package:expense_tracker/shared/extensions.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: context.colors.surface,
          elevation: 0,
          floating: false,
          title: Text(
            "Home",
            style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SliverToBoxAdapter(
          child: ExpenseCard(),
        ),
        SliverToBoxAdapter(
          child: AnalyticsCard(),
        ),
        const SliverStickyExpenseList(),
      ],
    );
  }
}
