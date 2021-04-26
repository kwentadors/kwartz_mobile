part of 'list_transaction_bloc.dart';

abstract class ListTransactionState extends Equatable {
  final DateTime dateFilter;

  ListTransactionState(DateTime this.dateFilter);

  @override
  List<Object> get props => [dateFilter];

  String get monthName => DateFormat.MMMM().format(this.dateFilter);
  String get year => DateFormat.y().format(this.dateFilter);

  String get previousMonthName => DateFormat.MMMM().format(this.previousMonth);
  String get previousMonthYear => DateFormat.y().format(this.previousMonth);

  String get nextMonthName => DateFormat.MMMM().format(this.nextMonth);
  String get nextMonthYear => DateFormat.y().format(this.nextMonth);

  DateTime get previousMonth => DateTime(
      this.dateFilter.year, this.dateFilter.month - 1, this.dateFilter.day);
  DateTime get nextMonth => DateTime(
      this.dateFilter.year, this.dateFilter.month + 1, this.dateFilter.day);

  static ListTransactionState get initial => ListTransactionInitial();
}

class ListTransactionInitial extends ListTransactionState {
  ListTransactionInitial() : super(DateTime.now());
}

class ListTransactionLoading extends ListTransactionState {
  ListTransactionLoading(DateTime dateFilter) : super(dateFilter);
}

class ListTransactionReady extends ListTransactionState {
  final List<Transaction> transactions;

  ListTransactionReady(DateTime dateFilter, this.transactions)
      : super(dateFilter);

  @override
  List<Object> get props => super.props + [transactions];
}
