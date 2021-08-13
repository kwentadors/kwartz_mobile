import 'dart:math';

class IncomeExpenseReport {
  Map<int, double> get income => {
        DateTime.july: 74463.70,
        DateTime.june: 59342.80,
        DateTime.may: 61174.50,
        DateTime.april: 113168.45,
        DateTime.march: 72761.86,
        DateTime.february: 78200.95,
      };

  Map<int, double> get expenses => {
        DateTime.july: 43415.92,
        DateTime.june: 38707.92,
        DateTime.may: 39559.09,
        DateTime.april: 29334.30,
        DateTime.march: 39679.46,
        DateTime.february: 36718.93,
      };

  double get netAmount => income.values.last - expenses.values.last;
}

class IncomeExpenseChartMetadata {
  final IncomeExpenseReport report;

  IncomeExpenseChartMetadata(this.report);

  double get maxRange => _maxValue + interval / 3;
  double get minRange => _minValue - interval / 3;

  double get interval => (_minValue + _maxValue) / 4;

  double get _maxValue {
    double maxIncome = this.report.income.values.reduce(max);
    double maxExpense = this.report.expenses.values.reduce(max);

    return max<double>(maxIncome, maxExpense);
  }

  double get _minValue {
    double minIncome = this.report.income.values.reduce(min);
    double minExpense = this.report.expenses.values.reduce(min);

    return min<double>(minIncome, minExpense);
  }
}
