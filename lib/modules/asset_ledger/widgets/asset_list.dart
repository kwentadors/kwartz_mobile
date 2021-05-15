import 'package:flutter/material.dart';
import '../../../utils/text_utils.dart';

class AssetList extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AssetList({Key key, this.data}) : super(key: key);
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
    @required this.assetGroupName,
    @required this.assetGroupEntries,
  }) : super(key: key);

  final String assetGroupName;
  final List assetGroupEntries;

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
