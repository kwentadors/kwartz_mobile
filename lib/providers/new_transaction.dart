import 'package:flutter/material.dart';
import '../models/transaction.dart';

class NewTransaction with ChangeNotifier {
  Transaction transaction = Transaction();

  void setDebitAmount(double amount) {
    transaction.debitAmount = amount;
    notifyListeners();
  }

  double get debitAmount => transaction.debitAmount;
}
