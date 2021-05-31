import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../modules/transaction/screens/asset_ledger_page.dart';
import '../modules/transaction/screens/save_transaction_page.dart';
import '../modules/transaction/screens/list_transaction_page.dart';

class Routes {
  static const TransactionList = 'transaction.list';
  static const TransactionNew = 'transaction.new';
  static const LedgerList = 'ledger.list';
}

class KwartzRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.TransactionList:
        return PageTransition(
          type: PageTransitionType.fade,
          child: ListTransactionsPage(),
        );
      case Routes.LedgerList:
        return PageTransition(
          type: PageTransitionType.fade,
          child: AssetLedgerPage(),
        );

      case Routes.TransactionNew:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: SaveTransactionPage(),
        );

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
