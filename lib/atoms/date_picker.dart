import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController controller;
  final Function validator;
  final String labelText;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat formatter;

  const DatePicker(
      {Key key,
      this.controller,
      this.validator,
      this.labelText,
      @required this.initialDate,
      @required this.firstDate,
      @required this.lastDate,
      @required this.formatter})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: widget.initialDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
        );
        this.widget.controller.text = widget.formatter.format(date);
      },
    );
  }
}
