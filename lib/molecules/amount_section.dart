import 'package:flutter/material.dart';
import 'package:kwartz_mobile/providers/new_transaction.dart';
import 'package:provider/provider.dart';

class TotalAmountSection extends StatelessWidget {
  final double debitAmount;
  final double creditAmount;

  const TotalAmountSection({this.debitAmount, this.creditAmount});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTransaction>(
      builder: (context, transaction, child) {
        // if (debitAmount == creditAmount) {
        return textAmountView(context, transaction.debitAmount);
        // } else {
        //   return errorView(context);
        // }
      },
    );
  }

  Row textAmountView(BuildContext context, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Amount",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          amount != null ? amount.toStringAsFixed(2) : "0.00",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Row errorView(BuildContext context) {
    return Row(
      children: [
        Text(
          "The debit and credit amounts do not match.",
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
      ],
    );
  }
}
