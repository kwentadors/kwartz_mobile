import 'package:flutter/material.dart';
import '../models/transaction.dart';

class NewTransaction with ChangeNotifier {
  Transaction _transaction;

  NewTransaction() {
    _transaction = Transaction();
    _transaction.createDebitEntry();
    _transaction.createCreditEntry();
  }

  void setTransactionDate(DateTime trxDate) {
    // _transaction.transactionDate = trxDate;
    notifyListeners();
  }

  JournalEntry createDebitEntry() {
    var journalEntry = _transaction.createDebitEntry();
    notifyListeners();
    return journalEntry;
  }

  JournalEntry createCreditEntry() {
    var journalEntry = _transaction.createCreditEntry();
    notifyListeners();
    return journalEntry;
  }

  void setDebitEntryAt(int position, JournalEntry entry) {
    _transaction.debitEntries[position] = entry;
    notifyListeners();
  }

  Transaction get transaction => _transaction;
  DateTime get transactionDate => _transaction.transactionDate;

  List<JournalEntryProvider> get debitEntries => _transaction.debitEntries
      .map((e) => JournalEntryProvider(this, e))
      .toList();

  List<JournalEntryProvider> get creditEntries => _transaction.creditEntries
      .map((e) => JournalEntryProvider(this, e))
      .toList();

  double get debitAmount => _transaction.debitEntries
      .fold(0, (previousValue, element) => previousValue + element.amount);

  double get creditAmount => _transaction.creditEntries
      .fold(0, (previousValue, element) => previousValue + element.amount);

  static NewTransaction create() {
    var instance = NewTransaction();
    return instance;
  }

  static NewTransaction from(Transaction transaction) {
    var instance = NewTransaction();
    instance._transaction = transaction;
    return instance;
  }
}

class JournalEntryProvider with ChangeNotifier {
  final NewTransaction transaction;
  final JournalEntry entry;

  JournalEntryProvider(this.transaction, this.entry);

  void setAccount(FinancialAccount value) {
    entry.account = value;
    notifyListeners();
  }

  void setAmount(double value) {
    entry.amount = value;
    notifyListeners();
  }

  double get amount => entry.amount;
  FinancialAccount get account => entry.account;
}
