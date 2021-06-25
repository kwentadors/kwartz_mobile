part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class SaveTransaction extends TransactionEvent {
  final Transaction transaction;

  SaveTransaction(this.transaction);
}

class ResetTransaction extends TransactionEvent {}

class AddDebitEntryEvent extends TransactionEvent {}

class AddCreditEntryEvent extends TransactionEvent {}
