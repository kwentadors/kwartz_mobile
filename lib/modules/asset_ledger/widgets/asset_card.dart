import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwartz_mobile/utils/text_utils.dart';
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
              children: [
                Text(
                  "Assets",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 8),
                if (state is AssetLedgerLoading) _buildLoadingSpinner(context),
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
        // backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Column _buildAssetFigures(BuildContext context, AssetLedgerReady state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatCurrency(state.balance),
          style: Theme.of(context).textTheme.headline5.copyWith(
                color:
                    state.changePercent > 0 ? Colors.greenAccent : Colors.red,
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 5),
            Text(
              "${state.changePercent.abs().toStringAsFixed(2)}%",
              style: TextStyle(
                color: state.changePercent > 0
                    ? Colors.greenAccent
                    : Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            state.changePercent > 0
                ? Icon(
                    Icons.arrow_drop_up,
                    color: Colors.greenAccent,
                  )
                : Icon(
                    Icons.arrow_drop_down,
                    color: Colors.redAccent,
                  ),
          ],
        ),
      ],
    );
  }
}
