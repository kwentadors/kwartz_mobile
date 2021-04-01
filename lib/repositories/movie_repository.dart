import 'package:kwartz_mobile/models/transaction.dart';

class MovieRepository {
  Future<Transaction> save(Transaction transaction) async {
    await Future.delayed(Duration(seconds: 10));
    print(transaction.toString());
    return transaction;
  }
}
