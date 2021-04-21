part of 'list_transaction_bloc.dart';

abstract class ListTransactionState extends Equatable {
  final List<Transaction> transactions;

  const ListTransactionState(this.transactions);

  @override
  List<Object> get props => [transactions];

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
