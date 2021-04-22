part of 'list_transaction_bloc.dart';

abstract class ListTransactionEvent extends Equatable {
  const ListTransactionEvent();

  @override
  List<Object> get props => [];
}

class FetchTransactionsEvent extends ListTransactionEvent {}

class UpdateDateFilterEvent extends ListTransactionEvent {
  final DateTime dateFilter;

  UpdateDateFilterEvent(this.dateFilter);
}
