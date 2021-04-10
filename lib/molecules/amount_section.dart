import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/transaction_bloc.dart';

class TotalAmountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        var transaction = state.transaction;
        if (transaction.debitAmount == 0 || transaction.creditAmount == 0) {
          return Row();
        }

        if (transaction.debitAmount != transaction.creditAmount) {
          return errorView(context);
        }

        return textAmountView(context, transaction.debitAmount);
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
          NumberFormat.simpleCurrency(decimalDigits: 2, name: "Php ")
              .format(amount),
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
