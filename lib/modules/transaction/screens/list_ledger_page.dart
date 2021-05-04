import 'package:flutter/material.dart';
import '../../../utils/text_utils.dart';

class ListLedgerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ledger")),
      body: ListLedgerBody(),
    );
  }
}

class ListLedgerBody extends StatelessWidget {
  const ListLedgerBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Assets"),
                    Text(
                      formatCurrency(523720.72),
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Change"),
                        Text("${2.45.toStringAsFixed(2)}%"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Previous"),
                        Text(formatCurrency(518720.11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
