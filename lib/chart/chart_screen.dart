import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, width: 15)]),
    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, width: 15)]),
    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, width: 15)]),
    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, width: 15)]),
  ];

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.chart_screen_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blueGrey,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String weekDay;
                  switch (group.x.toInt()) {
                    case 0:
                      weekDay = 'Monday';
                      break;
                    case 1:
                      weekDay = 'Tuesday';
                      break;
                    case 2:
                      weekDay = 'Wednesday';
                      break;
                    case 3:
                      weekDay = 'Thursday';
                      break;
                    default:
                      throw Error();
                  }
                  return BarTooltipItem(
                    '$weekDay\n${rod.toY - 1}',
                    const TextStyle(color: Colors.yellow),
                  );
                },
              ),
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 1500),
          // Animation duration
          swapAnimationCurve: Curves.linear, // Animation curve
        ),
      ),
    );
  }
}
