import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kwartz_mobile/blocs/transaction_bloc.dart';
import '../atoms/date_picker.dart';

class TransactionDatePicker extends StatefulWidget {
  const TransactionDatePicker({Key key}) : super(key: key);

  @override
  _TransactionDatePickerState createState() => _TransactionDatePickerState();
}

class _TransactionDatePickerState extends State<TransactionDatePicker> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var transaction = (BlocProvider.of<TransactionBloc>(context).state
            as EditingTransactionState)
        .transaction;

    var formatter = DateFormat("MMMM dd, y (EEEE)");
    controller.text = formatter.format(transaction.transactionDate);

    return DatePicker(
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Select a transaction date";
        }
        return null;
      },
      labelText: "Transaction Date",
      initialDate: transaction.transactionDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365)),
      formatter: formatter,
      onChanged: (value) {
        BlocProvider.of<TransactionBloc>(context)
            .add(UpdateTransactionDate(value));
      },
    );
  }
}
