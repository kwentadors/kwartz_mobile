part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {
  final Transaction transaction;

  TransactionState(this.transaction);
}

class EditingTransactionState extends TransactionState {
  EditingTransactionState(Transaction transaction) : super(transaction);
}

class TransactionSaving extends TransactionState {
  TransactionSaving(Transaction transaction) : super(transaction);
}

class TransactionSaveSuccess extends TransactionState {
  final Transaction savedTransaction;
  TransactionSaveSuccess(this.savedTransaction) : super(Transaction.initial());
}

class TransactionSaveError extends TransactionState {
  final Exception cause;

  TransactionSaveError(Transaction transaction, this.cause)
      : super(transaction);
}
