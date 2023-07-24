// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/features/admin/models/sales.dart';
import 'package:shoppy/utils/extensions/color_extensions.dart';

class CategoryProductsChart extends StatefulWidget {
  final List<Sales> sales;
  CategoryProductsChart({
    Key? key,
    required this.sales,
  }) : super(key: key);
  final Color leftBarColor = AppColors.contentColorYellow;
  final Color rightBarColor = AppColors.contentColorRed;
  final Color avgColor =
      AppColors.contentColorOrange.avg(AppColors.contentColorRed);
  @override
  State<CategoryProductsChart> createState() => _CategoryProductsChartState();
}

class _CategoryProductsChartState extends State<CategoryProductsChart> {
  final double width = 7;
  late int maxEarning;

  late List<BarChartGroupData> showingBarGroups;

  double calcLineHeight(int current, int max) {
    return 20 * current / max;
  }

  @override
  void initState() {
    super.initState();
    maxEarning = List<int>.from(widget.sales.map((Sales sale) => sale.earning))
        .reduce(max);

    final items = widget.sales
        .asMap()
        .entries
        .map((map) => makeGroupData(
            map.key, calcLineHeight(map.value.earning, maxEarning)))
        .toList();

    showingBarGroups = items;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                  ),
                  titlesData: FlTitlesData(
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
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 1,
                        getTitlesWidget: (value, meta) =>
                            leftTitles(value, meta, maxEarning),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta, int maxEarning) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 10) {
      text = '\$${(maxEarning ~/ 2)}';
    } else if (value == 20) {
      text = "\$$maxEarning";
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles =
        List<String>.from(widget.sales.map((Sales sale) => sale.label));

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: widget.leftBarColor,
          width: width,
        ),
      ],
    );
  }
}
