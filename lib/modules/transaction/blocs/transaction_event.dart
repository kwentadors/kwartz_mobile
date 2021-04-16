part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class SaveTransaction extends TransactionEvent {
  final Transaction transaction;

  SaveTransaction(this.transaction);
}

class UpdateTransactionDate extends TransactionEvent {
  final DateTime transactionDate;

  UpdateTransactionDate(this.transactionDate);
}

class AddDebitEntryEvent extends TransactionEvent {}

class AddCreditEntryEvent extends TransactionEvent {}

class UpdateDebitEntry extends TransactionEvent {
  final int index;
  final JournalEntry journalEntry;

  UpdateDebitEntry(this.index, this.journalEntry);
}

class UpdateCreditEntry extends TransactionEvent {
  final int index;
  final JournalEntry journalEntry;

  UpdateCreditEntry(this.index, this.journalEntry);
}
