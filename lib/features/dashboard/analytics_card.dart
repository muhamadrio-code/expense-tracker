import 'package:expense_tracker/shared/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnalyticsCard extends StatelessWidget {
  final double _height;
  final EdgeInsetsGeometry _margin;
  final EdgeInsetsGeometry _padding;
  final BorderRadius _borderRadius;
  final Color _backContainerColor;
  final Color _frontContainerColor;
  final String _title;
  final TextStyle _titleTextStyle;
  final TextStyle _monthTextStyle;

  AnalyticsCard({
    double height = 200,
    String title = "Analytics",
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? frontContainerColor,
    Color? backContainerColor,
    TextStyle? titleTextStyle,
    TextStyle? monthTextStyle,
    super.key,
  })  : _height = height,
        _borderRadius = borderRadius ?? BorderRadius.circular(16),
        _title = title,
        _titleTextStyle =
            titleTextStyle ?? const TextStyle(color: Colors.white),
        _margin = margin ?? const EdgeInsets.all(16),
        _padding = padding ?? const EdgeInsets.all(8),
        _monthTextStyle =
            titleTextStyle ?? const TextStyle(color: Colors.white24),
        _frontContainerColor =
            frontContainerColor ?? const Color.fromARGB(255, 35, 36, 35),
        _backContainerColor =
            backContainerColor ?? const Color.fromRGBO(255, 241, 118, 1);

  String _formatMonthWithWeek(String month, int weekOfMonth) {
    return "${month.capitalize()} Q'$weekOfMonth";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BackContainer(
          backgroundColor: _backContainerColor,
          borderRadius: _borderRadius,
          height: _height,
          margin: _margin,
        ),
        _ChartLayout(
          height: _height,
          margin: _margin,
          padding: _padding,
          backgroundColor: _frontContainerColor,
          borderRadius: _borderRadius,
          title: _ChartLayoutTitle(
            _title,
            //TODO: Get the current month and WeekOfMonth from Bloc.
            subtitle: _formatMonthWithWeek("October", 4),
            titleTextStyle: _titleTextStyle,
            subtitleTextStyle: _monthTextStyle,
          ),
          chart: _makeChart(),
        )
      ],
    );
  }

  Widget _makeChart() {
    return BarChart(
      BarChartData(
        maxY: 20,
        titlesData: _defaultChartTitlesData,
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: [
          makeGroupData(0, 5),
          makeGroupData(1, 8),
          makeGroupData(2, 8),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: 8,
                color: Colors.red[300],
                width: 12,
              ),
            ],
          ),
          makeGroupData(4, 6),
          makeGroupData(5, 9),
          makeGroupData(6, 10),
        ],
        gridData: const FlGridData(show: false),
      ),
    );
  }

  FlTitlesData get _defaultChartTitlesData => FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitles,
            reservedSize: 42,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.yellow[300],
          width: 12,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}

class _BackContainer extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Color backgroundColor;

  const _BackContainer({
    required this.height,
    required this.margin,
    required this.backgroundColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 70,
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class _ChartLayout extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Widget title;
  final Widget chart;

  const _ChartLayout({
    required this.height,
    required this.margin,
    required this.padding,
    required this.backgroundColor,
    required this.borderRadius,
    required this.title,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        margin: margin,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            title,
            Expanded(child: chart),
          ],
        ));
  }
}

class _ChartLayoutTitle extends StatelessWidget {
  final String data;
  final String subtitle;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;

  const _ChartLayoutTitle(
    this.data, {
    required this.subtitle,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            data,
            style: titleTextStyle,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: subtitleTextStyle,
        ),
      ],
    );
  }
}
