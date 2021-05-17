import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/text_utils.dart';
import '../blocs/asset_ledger_bloc.dart';
import '../models/asset_report.dart';

class AssetList extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AssetList({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetLedgerBloc, AssetLedgerState>(
      builder: (context, state) {
        if (state is AssetLedgerLoading || state is AssetLedgerInitial) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is AssetLedgerReady) {
          final assetReportGroups = state.assetReport.groups;

          return ListView.separated(
            itemBuilder: (context, index) {
              final assetReportGroup = assetReportGroups[index];
              return AssetGroupTile(assetReportGroup: assetReportGroup);
            },
            separatorBuilder: (context, index) => Divider(height: 10),
            itemCount: assetReportGroups.length,
          );
        }
      },
    );
  }
}

class AssetGroupTile extends StatelessWidget {
  const AssetGroupTile({
    Key key,
    @required this.assetReportGroup,
  }) : super(key: key);

  final AssetReportGroup assetReportGroup;

  @override
  Widget build(BuildContext context) {
    final assetReportGroupEntries = this.assetReportGroup.entries;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(assetReportGroup.name),
          ),
        ),
        Card(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => AssetReportGroupEntryTile(
              entry: assetReportGroupEntries[index],
            ),
            itemCount: assetReportGroupEntries.length,
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ],
    );
  }
}

class AssetReportGroupEntryTile extends StatelessWidget {
  const AssetReportGroupEntryTile({
    Key key,
    @required this.entry,
  }) : super(key: key);

  final AssetReportGroupEntry entry;

  @override
  Widget build(BuildContext context) {
    if (entry.description != null) {
      return ListTile(
        title: Text(entry.name),
        subtitle: Text(entry.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatCurrency(entry.amount)),
            Icon(Icons.trending_up),
          ],
        ),
      );
    } else {
      return ListTile(
        isThreeLine: false,
        title: Text(entry.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatCurrency(entry.amount)),
            Icon(Icons.trending_up),
          ],
        ),
      );
    }
  }
}
