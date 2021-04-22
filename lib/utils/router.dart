import 'package:flutter/material.dart';
import '../modules/transaction/screens/save_transaction_page.dart';
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
        return _slideFromRight(SaveTransactionPage());

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

  static PageRouteBuilder _slideFromRight(SaveTransactionPage page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }
}
