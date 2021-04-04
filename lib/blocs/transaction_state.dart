part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {
  final Transaction transaction;

  TransactionState(this.transaction);
}

class TransactionInitial extends TransactionState {
  TransactionInitial(Transaction transaction) : super(transaction);
}

class TransactionSaving extends TransactionState {
  TransactionSaving(Transaction transaction) : super(transaction);
}

class EditingTransactionState extends TransactionState {
  EditingTransactionState(Transaction transaction) : super(transaction);
}

class TransactionSaveSuccess extends TransactionState {
  TransactionSaveSuccess(Transaction transaction) : super(transaction);
}

class TransactionSaveError extends TransactionState {
  final Exception cause;

  TransactionSaveError(Transaction transaction, this.cause)
      : super(transaction);
}
