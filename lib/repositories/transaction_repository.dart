import 'package:intl/intl.dart';

import 'api.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final apiClient = ApiClient();

  static final formatter = DateFormat("y-MM-dd");
  static const URL = "/api/v1/transactions/";

  Future<Transaction> save(Transaction transaction) async {
    final requestBody = encode(transaction);
    var response = await apiClient.post(path: URL, body: requestBody);

    return decode(response);
  }

  Map<String, Object> encode(Transaction transaction) {
    return {
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
  }

  Transaction decode(Map<String, Object> properties) {
    var transaction = (Transaction(
        transactionDate: DateTime.parse(properties['transaction_date']),
        description: properties['description']));

    (properties['credit'] as List).forEach((element) {
      transaction.createCreditEntry()
        ..account = FinancialAccount(element['account']['name'])
        ..amount = element['amount'].toDouble();
    });

    (properties['debit'] as List).forEach((element) {
      transaction.createDebitEntry()
        ..account = FinancialAccount(element['account']['name'])
        ..amount = element['amount'].toDouble();
    });

    return transaction;
  }
}
