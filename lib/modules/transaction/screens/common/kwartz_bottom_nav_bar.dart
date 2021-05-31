import 'package:flutter/material.dart';
import 'package:kwartz_mobile/utils/router.dart';

class KwartzNavigation {
  static const Transactions = 0;
  static const Reports = 1;
}

class KwartzBottomNavigationBar extends StatelessWidget {
  final int navigationIndex;

  const KwartzBottomNavigationBar(
    this.navigationIndex, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list_alt,
          ),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.leaderboard,
          ),
          label: 'Reports',
        ),
      ],
      currentIndex: navigationIndex,
      onTap: (navIndex) {
        switch (navIndex) {
          case KwartzNavigation.Reports:
            Navigator.of(context).pushReplacementNamed(Routes.LedgerList);
            break;
          case KwartzNavigation.Transactions:
            Navigator.of(context).pushReplacementNamed(Routes.TransactionList);
            break;
          default:
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Unhandled navigation"),
                ),
              );
        }
      },
    );
  }
}
