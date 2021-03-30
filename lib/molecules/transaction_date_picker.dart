import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwartz_mobile/providers/new_transaction.dart';
import 'package:provider/provider.dart';
import '../atoms/date_picker.dart';

class TransactionDatePicker extends StatefulWidget {
  final TextEditingController controller;

  const TransactionDatePicker({Key key, this.controller}) : super(key: key);

  @override
  _TransactionDatePickerState createState() => _TransactionDatePickerState();
}

class _TransactionDatePickerState extends State<TransactionDatePicker> {
  @override
  Widget build(BuildContext context) {
    var transaction = Provider.of<NewTransaction>(context);

    var formatter = DateFormat("MMMM dd, y (EEEE)");
    this.widget.controller.text = formatter.format(transaction.transactionDate);

    return DatePicker(
      controller: this.widget.controller,
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
        transaction.setTransactionDate(value);
      },
    );
  }
}
