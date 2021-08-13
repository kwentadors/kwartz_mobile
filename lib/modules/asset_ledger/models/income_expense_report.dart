import 'dart:math';

class IncomeExpenseReport {
  final _incomeEntries = Map<int, double>();
  final _expenseEntries = Map<int, double>();

  Map<int, double> get income => _incomeEntries;

  Map<int, double> get expenses => _expenseEntries;

  double get netAmount =>
      income.values.last -
      (_expenseEntries.isNotEmpty ? _expenseEntries.values.last : 0);

  void setIncome(int month, int year, double income) {
    int key = _serializeKey(month, year);
    _incomeEntries[key] = income;
  }

  void setExpense(int month, int year, double expense) {
    int key = _serializeKey(month, year);
    _expenseEntries[key] = expense;
  }

  int _serializeKey(int month, int year) {
    final BASE_YEAR = 1900;
    return (year - BASE_YEAR) * 12 + (month - 1);
  }
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
