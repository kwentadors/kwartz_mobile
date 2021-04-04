import 'package:flutter/material.dart';

class Transaction {
  final DateTime transactionDate;
  final String description;
  final List<JournalEntry> debitEntries;
  final List<JournalEntry> creditEntries;

  const Transaction({
    this.transactionDate,
    this.description,
    this.debitEntries,
    this.creditEntries,
  });

  double get debitAmount => debitEntries.fold(
      0, (previousValue, element) => previousValue + element.amount);

  double get creditAmount => creditEntries.fold(
      0, (previousValue, element) => previousValue + element.amount);

  Transaction.initial()
      : this(
          transactionDate: DateTime.now(),
          description: null,
          debitEntries: <JournalEntry>[],
          creditEntries: <JournalEntry>[],
        );

  JournalEntry createDebitEntry() {
    var entry = JournalEntry(this);
    debitEntries.add(entry);
    return entry;
  }

  JournalEntry createCreditEntry() {
    var entry = JournalEntry(this);
    creditEntries.add(entry);
    return entry;
  }

// TODO verify the entries have the same amount
  double get amount => debitEntries.fold(0, (sum, entry) => sum + entry.amount);

  Transaction copyWith({
    DateTime transactionDate,
  }) {
    return Transaction(
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }
}

class JournalEntry {
  FinancialAccount account;
  double amount = 0.0;
  final Transaction transaction;

  JournalEntry(this.transaction);
}

@immutable
class FinancialAccount {
  final String name;

  FinancialAccount(this.name);

  @override
  bool operator ==(Object other) {
    return other is FinancialAccount && name == other.name;
  }
}
