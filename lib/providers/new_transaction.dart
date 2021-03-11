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
    _transaction.transactionDate = trxDate;
    notifyListeners();
  }

  void setAccount(FinancialAccount account) {
    _transaction.account = account;
    notifyListeners();
  }

  void setDebitAmount(double amount) {
    _transaction.debitAmount = amount;
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

  DateTime get transactionDate => _transaction.transactionDate;
  FinancialAccount get account => _transaction.account;
  double get debitAmount => _transaction.debitAmount;

  JournalEntry getDebitEntryAt(int position) {
    return _transaction.debitEntries[position];
  }

  List<JournalEntryProvider> get debitEntries =>
      _transaction.debitEntries.map((e) => JournalEntryProvider(e)).toList();

  List<JournalEntryProvider> get creditEntries =>
      _transaction.creditEntries.map((e) => JournalEntryProvider(e)).toList();

  static NewTransaction create() {
    var instance = NewTransaction();
    return instance;
  }
}

class JournalEntryProvider with ChangeNotifier {
  final JournalEntry entry;

  JournalEntryProvider(this.entry);

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
