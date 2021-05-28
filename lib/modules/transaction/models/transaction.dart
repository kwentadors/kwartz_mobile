import 'package:flutter/material.dart';

class Transaction {
  DateTime transactionDate;
  String description;
  List<JournalEntry> debitEntries = <JournalEntry>[];
  List<JournalEntry> creditEntries = <JournalEntry>[];

  Transaction({
    this.transactionDate,
    this.description,
    this.debitEntries,
    this.creditEntries,
  });

  double get debitAmount => debitEntries.fold(
      0, (previousValue, element) => previousValue + element.amount);

  double get creditAmount => creditEntries.fold(
      0, (previousValue, element) => previousValue + element.amount);

  static initial() {
    var transaction = Transaction(
      transactionDate: DateTime.now(),
      description: null,
      debitEntries: <JournalEntry>[],
      creditEntries: <JournalEntry>[],
    );
    transaction.createDebitEntry();
    transaction.createCreditEntry();

    return transaction;
  }

  JournalEntry createDebitEntry() {
    if (debitEntries == null) {
      debitEntries = <JournalEntry>[];
    }
    var entry = JournalEntry(this, JournalEntryType.DEBIT);
    debitEntries.add(entry);
    return entry;
  }

  JournalEntry createCreditEntry() {
    if (creditEntries == null) {
      creditEntries = <JournalEntry>[];
    }
    var entry = JournalEntry(this, JournalEntryType.CREDIT);
    creditEntries.add(entry);
    return entry;
  }

  double get amount => debitEntries.fold(0, (sum, entry) => sum + entry.amount);

  Transaction copyWith({
    DateTime transactionDate,
  }) {
    return Transaction(
      transactionDate: transactionDate ?? this.transactionDate,
      description: this.description,
      debitEntries: this.debitEntries,
      creditEntries: this.creditEntries,
    );
  }

  Transaction withNewDebitEntry() {
    return copyWith()..createDebitEntry();
  }

  Transaction withNewCreditEntry() {
    return copyWith()..createCreditEntry();
  }
}

enum JournalEntryType { CREDIT, DEBIT }

class JournalEntry {
  final Transaction transaction;
  final JournalEntryType type;
  FinancialAccount account;
  double amount;

  JournalEntry(this.transaction, this.type, {this.account, this.amount = 0.0});

  JournalEntry copyWith({FinancialAccount account, double amount}) {
    return JournalEntry(
      transaction,
      type,
      account: account ?? this.account,
      amount: amount ?? this.amount,
    );
  }
}

@immutable
class FinancialAccount {
  final int id;
  final String name;

  FinancialAccount(this.id, this.name);

  @override
  bool operator ==(Object other) {
    return other is FinancialAccount && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
