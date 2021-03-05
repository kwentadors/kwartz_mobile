import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return DatePicker(
      controller: this.widget.controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Select a transaction date";
        }
        return null;
      },
      labelText: "Transaction Date",
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365)),
      formatter: DateFormat("MMMM dd, y (EEEE)"),
    );
  }
}
