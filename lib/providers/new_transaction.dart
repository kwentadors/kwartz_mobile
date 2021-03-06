import 'package:flutter/material.dart';
import '../models/transaction.dart';

class NewTransaction with ChangeNotifier {
  Transaction transaction = Transaction();

  void setTransactionDate(DateTime trxDate) {
    transaction.transactionDate = trxDate;
    notifyListeners();
  }

  void setDebitAmount(double amount) {
    transaction.debitAmount = amount;
    notifyListeners();
  }

  DateTime get transactionDate => transaction.transactionDate;
  double get debitAmount => transaction.debitAmount;
}
