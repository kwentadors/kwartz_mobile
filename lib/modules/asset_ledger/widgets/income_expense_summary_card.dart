import 'package:flutter/material.dart';
import '../../../utils/text_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeExpenseSummaryCard extends StatelessWidget {
  final income = const [
    74463.70,
    59342.80,
    61174.50,
    113168.45,
    72761.86,
    78200.95
  ];
  final expenses = const [
    43415.92,
    38707.92,
    39559.09,
    39334.30,
    39679.46,
    37018.93
  ];

  const IncomeExpenseSummaryCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          children: [
            cardHeader(context),
            SizedBox(height: 8),
            // if (state is AssetLedgerLoading || state is AssetLedgerInitial)
            //   _buildLoadingSpinner(context),
            // if (state is AssetLedgerReady)
            _buildAssetFigures(context)
          ],
        ),
      ),
    );
  }

  Widget cardHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Income & Expense",
          textDirection: TextDirection.ltr,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        Text(
          formatCurrency(336623.22),
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // Container _buildLoadingSpinner(BuildContext context) {
  //   return Container(
  //     child: CircularProgressIndicator(
  //       valueColor: AlwaysStoppedAnimation<Color>(
  //         Theme.of(context).colorScheme.secondary,
  //       ),
  //       backgroundColor: Theme.of(context).colorScheme.onPrimary,
  //     ),
  //   );
  // }

  Widget _buildAssetFigures(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          _lineChartData(context),
          swapAnimationDuration: Duration(milliseconds: 850),
        ),
      ),
    );
  }

  LineChartData _lineChartData(BuildContext context) {
    final horizontalInterval = 30000.0;

    return LineChartData(
      minY: 5000,
      maxY: 120000,
      lineBarsData: [
        _incomeSeriesData(),
        _expenseSeriesData(),
      ],
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawHorizontalLine: true,
        horizontalInterval: horizontalInterval,
      ),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) {
            return TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            );
          },
          interval: horizontalInterval,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) {
            return TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            );
          },
          getTitles: (value) {
            return value.toString();
          },
        ),
      ),
    );
  }

  LineChartBarData _incomeSeriesData() {
    return LineChartBarData(
      colors: [Colors.greenAccent],
      isCurved: true,
      spots: _serialize(income),
      belowBarData: BarAreaData(
        show: true,
        colors: [Colors.greenAccent.withOpacity(0.3)],
      ),
    );
  }

  LineChartBarData _expenseSeriesData() {
    return LineChartBarData(
      colors: [Colors.redAccent],
      isCurved: true,
      spots: _serialize(expenses),
      belowBarData: BarAreaData(
        show: true,
        colors: [Colors.redAccent.withOpacity(0.3)],
      ),
    );
  }

  List<FlSpot> _serialize(List<double> seriesData) {
    return seriesData
        .asMap()
        .map((index, value) {
          return MapEntry(index, FlSpot(index.toDouble(), value));
        })
        .values
        .toList();
  }
}
