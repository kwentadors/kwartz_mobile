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
            key: ValueKey('asset-group-list'),
            itemBuilder: (context, index) {
              final assetReportGroup = assetReportGroups[index];
              return AssetGroupTile(assetReportGroup: assetReportGroup);
            },
            separatorBuilder: (context, index) => Divider(height: 10),
            itemCount: assetReportGroups.length,
          );
        } else {
          return Center(
            child: Text("Unhandled state"),
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
    final assetReportStyle = _getAssetReportStyle(entry.changePercent);
    final textStyle = TextStyle(
      color: assetReportStyle['color'],
      fontWeight: FontWeight.bold,
    );

    return ListTile(
      isThreeLine: (entry.description != null),
      title: _titleContent(textStyle),
      subtitle: (entry.description != null)
          ? Text(
              entry.description,
              style: textStyle,
            )
          : null,
      trailing: _trailingContent(assetReportStyle, textStyle),
    );
  }

  Widget _titleContent(TextStyle textStyle) {
    return Text(
      entry.name,
      style: textStyle,
    );
  }

  Widget _trailingContent(
      Map<String, dynamic> assetReportStyle, TextStyle textStyle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (assetReportStyle['icon'] != null) assetReportStyle['icon'],
        Text(
          formatCurrency(entry.amount),
          style: textStyle,
        ),
      ],
    );
  }
}

Map<String, dynamic> _getAssetReportStyle(double assetChange) {
  if (assetChange == null || assetChange == 0) {
    return {'color': Colors.grey};
  }

  if (assetChange > 0) {
    return {
      'color': Colors.green,
      'icon': Icon(
        Icons.arrow_drop_up,
        key: ValueKey("asset-change-icon"),
        textDirection: TextDirection.ltr,
        color: Colors.green,
      ),
    };
  }

  return {
    'color': Colors.red,
    'icon': Icon(
      Icons.arrow_drop_down,
      key: ValueKey("asset-change-icon"),
      textDirection: TextDirection.ltr,
      color: Colors.red,
    )
  };
}
