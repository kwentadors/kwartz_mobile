import 'package:flutter/material.dart';
import '../models/transaction.dart';

class NewTransaction with ChangeNotifier {
  Transaction transaction = Transaction();

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

  DateTime get transactionDate => transaction.transactionDate;
  FinancialAccount get account => transaction.account;
  double get debitAmount => transaction.debitAmount;
}
