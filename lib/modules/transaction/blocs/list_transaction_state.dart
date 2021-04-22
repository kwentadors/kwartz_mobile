part of 'list_transaction_bloc.dart';

abstract class ListTransactionState extends Equatable {
  DateTime _dateFilter;
  final List<Transaction> transactions;

  ListTransactionState(this.transactions) {
    this._dateFilter = DateTime.now();
  }

  @override
  List<Object> get props => [transactions];

  String get monthName => DateFormat.MMMM().format(this._dateFilter);
  String get year => DateFormat.y().format(this._dateFilter);

  static ListTransactionState get initial => ListTransactionInitial();
}

class ListTransactionInitial extends ListTransactionState {
  ListTransactionInitial() : super(null);
}

class ListTransactionLoading extends ListTransactionState {
  ListTransactionLoading() : super(null);
}

class ListTransactionReady extends ListTransactionState {
  ListTransactionReady(List<Transaction> transactions)
      : super(List.unmodifiable(transactions));
}
