import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final Function validator;
  final Function onChanged;
  final String labelText;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  DateFormat formatter;
  TextEditingController controller;

  DatePicker(
      {Key key,
      this.validator,
      this.labelText,
      @required this.initialDate,
      @required this.firstDate,
      @required this.lastDate,
      this.onChanged})
      : super(key: key) {
    this.controller = TextEditingController();
    this.formatter = DateFormat("MMMM dd, y (EEEE)");
    controller.text = formatter.format(initialDate);
  }

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      // onChanged: (value) => this.widget.onChanged(value),
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: widget.initialDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
        );

        if (date != null) {
          this.widget.controller.text = widget.formatter.format(date);
          this.widget.onChanged(date);
        }
      },
    );
  }
}
