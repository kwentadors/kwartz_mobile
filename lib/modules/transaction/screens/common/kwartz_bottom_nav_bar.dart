import 'package:flutter/material.dart';

class KwartzNavigation {
  static const Transactions = 0;
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
    );
  }
}
