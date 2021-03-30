import 'package:flutter/material.dart';

class Transaction {
  DateTime transactionDate = DateTime.now();
  List<JournalEntry> debitEntries = [];
  List<JournalEntry> creditEntries = [];

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
