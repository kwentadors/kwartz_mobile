import 'package:flutter/material.dart';
import 'package:kwartz_mobile/modules/transaction/screens/save_transaction_page.dart';
import '../modules/transaction/screens/list_transaction_page.dart';

class Routes {
  static const TransactionList = 'transaction.list';
  static const TransactionNew = 'transaction.new';
}

class KwartzRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print(settings);

    switch (settings.name) {
      case Routes.TransactionList:
        return MaterialPageRoute(builder: (_) => ListTransactionsPage());

      case Routes.TransactionNew:
        return MaterialPageRoute(builder: (_) => SaveTransactionPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("It's not you, it's us!"),
            ),
          ),
        );
    }
  }
}
