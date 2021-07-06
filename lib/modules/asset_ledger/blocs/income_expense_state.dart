part of 'income_expense_bloc.dart';

abstract class IncomeExpenseState extends Equatable {
  const IncomeExpenseState();

  @override
  List<Object> get props => [];
}

class IncomeExpenseInitial extends IncomeExpenseState {}

class IncomeExpenseReady extends IncomeExpenseState {
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
  double get maxRange => _maxValue + interval / 3;
  double get minRange => _minValue - interval / 3;

  double get interval => (_minValue + _maxValue) / 4;

  double get _maxValue {
    double maxIncome = income.values.reduce(max);
    double maxExpense = expenses.values.reduce(max);

    return max<double>(maxIncome, maxExpense);
  }

  double get _minValue {
    double minIncome = income.values.reduce(min);
    double minExpense = expenses.values.reduce(min);

    return min<double>(minIncome, minExpense);
  }
}
