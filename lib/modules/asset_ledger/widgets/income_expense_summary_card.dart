import 'package:flutter/material.dart';
import '../../../utils/text_utils.dart';

class IncomeExpenseSummaryCard extends StatelessWidget {
  const IncomeExpenseSummaryCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          children: [
            cardHeader(context),
            SizedBox(height: 8),
            // if (state is AssetLedgerLoading || state is AssetLedgerInitial)
            //   _buildLoadingSpinner(context),
            // if (state is AssetLedgerReady)
            _buildAssetFigures(context)
          ],
        ),
      ),
    );
  }

  Widget cardHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Income & Expense",
          textDirection: TextDirection.ltr,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        Text(
          formatCurrency(336623.22),
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // Container _buildLoadingSpinner(BuildContext context) {
  //   return Container(
  //     child: CircularProgressIndicator(
  //       valueColor: AlwaysStoppedAnimation<Color>(
  //         Theme.of(context).colorScheme.secondary,
  //       ),
  //       backgroundColor: Theme.of(context).colorScheme.onPrimary,
  //     ),
  //   );
  // }

  Column _buildAssetFigures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: TextDirection.ltr,
      children: [
        Text(
          formatCurrency(336623.22),
          key: ValueKey('asset-balance'),
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.headline5.copyWith(
                // color: assetReportStyle['color'],
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            SizedBox(width: 5),
            Text(
              "${(-22.65).abs().toStringAsFixed(2)}%",
              key: ValueKey('asset-change'),
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }
}
