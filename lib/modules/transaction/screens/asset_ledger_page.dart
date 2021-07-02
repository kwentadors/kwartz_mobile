import 'package:flutter/material.dart';
import 'package:kwartz_mobile/modules/asset_ledger/widgets/income_expense_summary_card.dart';
import 'common/kwartz_bottom_nav_bar.dart';
import '../../asset_ledger/widgets/asset_list.dart';
import '../../asset_ledger/widgets/asset_card.dart';

class AssetLedgerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ledger"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListLedgerBody(),
      bottomNavigationBar: KwartzBottomNavigationBar(KwartzNavigation.Reports),
    );
  }
}

class ListLedgerBody extends StatelessWidget {
  const ListLedgerBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120.0,
            child: AssetsCard(),
          ),
          SizedBox(height: 20),
          Expanded(child: AssetList())
        ],
      ),
    );
  }
}
