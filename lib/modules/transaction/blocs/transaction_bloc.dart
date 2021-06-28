import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository =
      new TransactionRepository();

  TransactionBloc() : super(EditingTransactionState(Transaction.initial()));

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is SaveTransaction) {
      yield* handleSaveTransaction(event);
    } else if (event is ResetTransaction) {
      yield EditingTransactionState(Transaction.initial());
    } else if (event is AddDebitEntryEvent) {
      var transaction = state.transaction;
      transaction.withNewDebitEntry();
      yield EditingTransactionState(transaction);
    } else if (event is AddCreditEntryEvent) {
      var transaction = state.transaction;
      transaction.withNewCreditEntry();
      yield EditingTransactionState(transaction);
    }
  }

  Stream<TransactionState> handleSaveTransaction(SaveTransaction event) async* {
    try {
      yield TransactionSaving(state.transaction);
      await _transactionRepository.save(event.transaction);
      yield TransactionSaveSuccess(state.transaction);
    } on Exception catch (e) {
      yield TransactionSaveError(state.transaction, e);
    }
  }
}
