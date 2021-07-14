import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/blocs/income_expense_bloc.dart';
import 'package:kwartz_mobile/utils/color_scheme.dart';
import 'package:kwartz_mobile/utils/date_utils.dart';
import '../../../utils/text_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeExpenseSummaryCard extends StatelessWidget {
  const IncomeExpenseSummaryCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeExpenseBloc, IncomeExpenseState>(
      builder: (context, state) {
        return Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              verticalDirection: VerticalDirection.down,
              textDirection: TextDirection.ltr,
              children: [
                cardHeader(context, state),
                SizedBox(height: 8),
                if (state is IncomeExpenseInitial)
                  _buildLoadingSpinner(context),
                if (state is IncomeExpenseReady)
                  _buildAssetFigures(context, state)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardHeader(BuildContext context, IncomeExpenseState state) {
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
        if (state is IncomeExpenseReady)
          Text(
            formatCurrency(state.report.netAmount),
            key: ValueKey('income-expense-net-amount'),
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color:
                      NetValueColorScheme.getColorScheme(state.report.netAmount)
                          .color,
                  fontWeight: FontWeight.bold,
                ),
          ),
      ],
    );
  }

  Container _buildLoadingSpinner(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildAssetFigures(BuildContext context, IncomeExpenseReady state) {
    return AspectRatio(
      key: ValueKey('income-expense-line-graph'),
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          _lineChartData(context, state),
          swapAnimationDuration: Duration(milliseconds: 850),
        ),
      ),
    );
  }

  LineChartData _lineChartData(BuildContext context, IncomeExpenseReady state) {
    final chartMetadata = state.chartMetadata;
    return LineChartData(
      minY: chartMetadata.minRange,
      maxY: chartMetadata.maxRange,
      lineBarsData: [
        _incomeSeriesData(state.report.income),
        _expenseSeriesData(state.report.expenses),
      ],
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawHorizontalLine: true,
        horizontalInterval: chartMetadata.interval,
      ),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) {
            return TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            );
          },
          interval: chartMetadata.interval,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) {
            return TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            );
          },
          getTitles: (double value) {
            return DateUtils.toMonthName(value.toInt() - 1);
          },
        ),
      ),
    );
  }

  LineChartBarData _incomeSeriesData(Map<int, double> income) {
    final colorScheme = NetValueColorScheme.POSITIVE_COLOR_SCHEME;
    return LineChartBarData(
      colors: [colorScheme.color],
      isCurved: true,
      spots: _serialize(income),
      belowBarData: BarAreaData(
        show: true,
        colors: [colorScheme.color.withOpacity(0.3)],
      ),
    );
  }

  LineChartBarData _expenseSeriesData(Map<int, double> expenses) {
    final colorScheme = NetValueColorScheme.NEGATIVE_COLOR_SCHEME;
    return LineChartBarData(
      colors: [colorScheme.color],
      isCurved: true,
      spots: _serialize(expenses),
      belowBarData: BarAreaData(
        show: true,
        colors: [colorScheme.color.withOpacity(0.3)],
      ),
    );
  }

  List<FlSpot> _serialize(Map<int, double> seriesData) {
    return seriesData
        .map((index, value) {
          return MapEntry(index, FlSpot(index.toDouble(), value));
        })
        .values
        .toList();
  }
}
