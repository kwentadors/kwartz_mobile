import 'package:flutter/material.dart';
import '../models/transaction.dart';

class NewTransaction with ChangeNotifier {
  Transaction transaction;

  NewTransaction() {
    transaction = Transaction();
    transaction.createDebitEntry();
  }

  void setTransactionDate(DateTime trxDate) {
    transaction.transactionDate = trxDate;
    notifyListeners();
  }

  void setAccount(FinancialAccount account) {
    transaction.account = account;
    notifyListeners();
  }

  void setDebitAmount(double amount) {
    transaction.debitAmount = amount;
    notifyListeners();
  }

  JournalEntry createDebitEntry() {
    transaction.createDebitEntry();
    notifyListeners();
    return JournalEntry();
  }

  void setDebitEntryAt(int position, JournalEntry entry) {
    transaction.debitEntries[position] = entry;
    notifyListeners();
  }

  DateTime get transactionDate => transaction.transactionDate;
  FinancialAccount get account => transaction.account;
  double get debitAmount => transaction.debitAmount;

  JournalEntry getDebitEntryAt(int position) {
    return transaction.debitEntries[position];
  }

  List<JournalEntry> get debitEntries => transaction.debitEntries;

  static NewTransaction create() {
    var instance = NewTransaction();
    return instance;
  }
}
