part of 'income_expense_bloc.dart';

abstract class IncomeExpenseState extends Equatable {
  const IncomeExpenseState();

  @override
  List<Object> get props => [];
}

class IncomeExpenseInitial extends IncomeExpenseState {}

class IncomeExpenseReady extends IncomeExpenseState {
  final IncomeExpenseReport report;

  IncomeExpenseReady(this.report);

  IncomeExpenseChartMetadata get chartMetadata =>
      IncomeExpenseChartMetadata(report);
}
