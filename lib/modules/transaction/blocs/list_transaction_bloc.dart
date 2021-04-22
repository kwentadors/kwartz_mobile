import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../repositories/transaction_repository.dart';
import '../models/transaction.dart';

part 'list_transaction_event.dart';
part 'list_transaction_state.dart';

class ListTransactionBloc
    extends Bloc<ListTransactionEvent, ListTransactionState> {
  final TransactionRepository repository;

  ListTransactionBloc(this.repository) : super(ListTransactionInitial());

  @override
  Stream<ListTransactionState> mapEventToState(
    ListTransactionEvent event,
  ) async* {
    if (event is FetchTransactionsEvent) {
      yield ListTransactionLoading(state.dateFilter);
      List<Transaction> transactions = await repository.fetchAll();
      yield ListTransactionReady(state.dateFilter, transactions);
    } else if (event is UpdateDateFilterEvent) {
      yield ListTransactionLoading(event.dateFilter);

      Future.delayed(Duration(seconds: 5));
      List<Transaction> transactions = List.empty();
      yield ListTransactionReady(event.dateFilter, transactions);
    } else {
      throw Exception("Unhandled event!");
    }
  }
}
