import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwartz_mobile/models/transaction.dart';
import '../repositories/movie_repository.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final MovieRepository _movieRepository = new MovieRepository();

  TransactionBloc() : super(EditingTransactionState(Transaction.initial()));

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is SaveTransaction) {
      yield* handleSaveTransaction(event);
    } else if (event is UpdateTransactionDate) {
      var transaction =
          state.transaction.copyWith(transactionDate: event.transactionDate);
      yield EditingTransactionState(transaction);
    }
  }

  Stream<TransactionState> handleSaveTransaction(SaveTransaction event) async* {
    try {
      yield TransactionSaving(state.transaction);
      await _movieRepository.save(event.transaction);
      yield TransactionSaveSuccess(state.transaction);
    } on Exception catch (e) {
      yield TransactionSaveError(state.transaction, e);
    }
  }
}
