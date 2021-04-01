import 'dart:convert';

import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:http/http.dart' as http;

class MovieRepository {
  final formatter = DateFormat("y-MM-dd");

  Future<Transaction> save(Transaction transaction) async {
    final url = "http://10.0.2.2:8000" + "/api/v1/transactions/";
    final requestBody = encode(transaction);

    print("Request URL:" + url);
    print("Request body: " + requestBody);
    var response = await http.post(url, body: requestBody, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    transaction = decode(response.body);
    return transaction;
  }

  String encode(Transaction transaction) {
    var properties = {
      "transaction_date": formatter.format(transaction.transactionDate),
      "amount": transaction.amount,
      "description": "Spent one-day millionaire",
      "debit": transaction.debitEntries
          .map((e) => {"account_id": 1, "amount": e.amount})
          .toList(),
      "credit": transaction.creditEntries
          .map((e) => {"account_id": 1, "amount": e.amount})
          .toList(),
    };
    return json.encode(properties);
  }

  Transaction decode(String response) {
    var map = json.decode(response);
    var transaction = (Transaction())
      ..transactionDate = DateTime.parse(map['transaction_date'])
      ..description = map['description'];

    (map['credit'] as List).forEach((element) {
      transaction.createCreditEntry()
        ..account = FinancialAccount(element['account']['name'])
        ..amount = element['amount'].toDouble();
    });

    (map['debit'] as List).forEach((element) {
      transaction.createDebitEntry()
        ..account = FinancialAccount(element['account']['name'])
        ..amount = element['amount'].toDouble();
    });

    return transaction;
  }
}
