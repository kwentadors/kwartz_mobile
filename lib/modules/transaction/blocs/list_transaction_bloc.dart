import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/transaction.dart';

part 'list_transaction_event.dart';
part 'list_transaction_state.dart';

class ListTransactionBloc
    extends Bloc<ListTransactionEvent, ListTransactionState> {
  ListTransactionBloc() : super(ListTransactionInitial());

  @override
  Stream<ListTransactionState> mapEventToState(
    ListTransactionEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is FetchTransactionsEvent) {
      yield ListTransactionLoading();
      await Future.delayed(Duration(seconds: 5));
      var transactions = <Transaction>[];
      yield ListTransactionReady(transactions);
    }
  }
}
