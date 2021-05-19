import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/text_utils.dart';
import '../blocs/asset_ledger_bloc.dart';

class AssetsCard extends StatelessWidget {
  const AssetsCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetLedgerBloc, AssetLedgerState>(
      builder: (context, state) {
        return Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              verticalDirection: VerticalDirection.down,
              textDirection: TextDirection.ltr,
              children: [
                Text(
                  "Assets",
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 8),
                if (state is AssetLedgerLoading || state is AssetLedgerInitial)
                  _buildLoadingSpinner(context),
                if (state is AssetLedgerReady)
                  _buildAssetFigures(context, state)
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildLoadingSpinner(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Column _buildAssetFigures(BuildContext context, AssetLedgerReady state) {
    final assetReport = state.assetReport;
    final assetReportStyle = _getAssetReportStyle(assetReport.changePercent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: TextDirection.ltr,
      children: [
        Text(
          formatCurrency(assetReport.balance),
          key: ValueKey('asset-balance'),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: assetReportStyle['color'],
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            SizedBox(width: 5),
            Text(
              "${assetReport.changePercent.abs().toStringAsFixed(2)}%",
              key: ValueKey('asset-change'),
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: assetReportStyle['color'],
                fontWeight: FontWeight.w600,
              ),
            ),
            if (assetReportStyle.containsKey('icon')) assetReportStyle['icon']
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _getAssetReportStyle(double assetChange) {
    if (assetChange > 0) {
      return {
        'color': Colors.greenAccent,
        'icon': Icon(
          Icons.arrow_drop_up,
          key: ValueKey("asset-change-icon"),
          textDirection: TextDirection.ltr,
          color: Colors.greenAccent,
        ),
      };
    }

    if (assetChange == 0) {
      return {'color': Colors.grey};
    }

    return {
      'color': Colors.redAccent,
      'icon': Icon(
        Icons.arrow_drop_down,
        key: ValueKey("asset-change-icon"),
        textDirection: TextDirection.ltr,
        color: Colors.redAccent,
      )
    };
  }
}
