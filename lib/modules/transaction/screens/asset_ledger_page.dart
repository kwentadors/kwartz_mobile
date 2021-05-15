import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../asset_ledger/widgets/asset_card.dart';
import '../../asset_ledger/blocs/asset_ledger_bloc.dart';
import '../../../utils/text_utils.dart';

class AssetLedgerPage extends StatelessWidget {
  final _data = [
    {
      'name': 'Cash and equivalents',
      'entries': [
        {
          "name": "Savings-BDO",
          "description": "Account Number: XXXXXXX8025",
          "amount": 27899.85
        },
        {
          "name": "Savings-Unionbank",
          "description": "Account Number: XXXXXXX9970",
          "amount": 3691.12
        },
      ]
    },
    {
      'name': 'Paper Investments',
      'entries': [
        {
          "name": "Stock Market - COL",
          "description": null,
          "amount": 5000.00,
        },
        {
          "name": "Stock Market - First Metro Sec",
          "description": null,
          "amount": 15000.00
        },
      ],
    },
    {
      'name': 'Property',
      'entries': [
        {
          "name": "Tayud House & Lot",
          "description": null,
          "amount": 285000.00,
        },
        {
          "name": "Bloq Residences - Unit 405",
          "description": null,
          "amount": 15000.00
        },
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssetLedgerBloc>(
      create: (context) => AssetLedgerBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ledger"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListLedgerBody(data: _data),
      ),
    );
  }
}

class ListLedgerBody extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const ListLedgerBody({Key key, this.data}) : super(key: key);

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
          Expanded(child: AssetCompositionList(data: data))
        ],
      ),
    );
  }
}

class AssetCompositionList extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AssetCompositionList({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final assetGroup = data[index];
        return AssetGroup(
          assetGroupName: assetGroup['name'],
          assetGroupEntries: assetGroup['entries'],
        );
      },
      separatorBuilder: (context, index) => Divider(height: 10),
      itemCount: data.length,
    );
  }
}

class AssetGroup extends StatelessWidget {
  const AssetGroup({
    Key key,
    @required String this.assetGroupName,
    @required List this.assetGroupEntries,
  }) : super(key: key);

  final assetGroupName;
  final assetGroupEntries;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(assetGroupName),
          ),
        ),
        Card(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final entry = assetGroupEntries[index];
              if (entry['description'] != null) {
                return ListTile(
                  title: Text(entry['name']),
                  subtitle: (Text(entry['description'] ?? "")),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(formatCurrency(entry['amount'])),
                      Icon(Icons.trending_up),
                    ],
                  ),
                );
              } else {
                return ListTile(
                  isThreeLine: false,
                  title: Text(entry['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(formatCurrency(entry['amount'])),
                      Icon(Icons.trending_up),
                    ],
                  ),
                );
              }
            },
            itemCount: assetGroupEntries.length,
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ],
    );
  }
}
