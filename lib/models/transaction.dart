import 'package:flutter/material.dart';

class Transaction {
  DateTime transactionDate = DateTime.now();
  FinancialAccount account;
  double debitAmount = 0.0;
}

class FinancialAccount {
  String name;

  FinancialAccount({@required this.name});
}
