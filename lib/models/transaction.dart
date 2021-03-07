import 'package:flutter/material.dart';

class Transaction {
  DateTime transactionDate = DateTime.now();
  FinancialAccount account;
  double debitAmount = 0.0;

  List<JournalEntry> debitEntries = [];

  JournalEntry createDebitEntry() {
    var entry = JournalEntry();
    debitEntries.add(entry);
    return entry;
  }
}

class JournalEntry {
  FinancialAccount account;
  double amount = 0.0;
}

class FinancialAccount {
  String name;

  FinancialAccount({@required this.name});
}
