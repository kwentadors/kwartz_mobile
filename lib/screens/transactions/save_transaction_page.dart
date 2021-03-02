import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SaveTransactionPage extends StatefulWidget {
  @override
  _SaveTransactionPageState createState() => _SaveTransactionPageState();
}

class _SaveTransactionPageState extends State<SaveTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _transactionDateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 16.0);

    var debitInputSection = [
      sectionTitlePadding,
      dividerWidget('Debit'),
      JournalEntryWidget(),
      sectionTitlePadding,
    ];

    var creditInputSection = [
      sectionTitlePadding,
      dividerWidget('Credit'),
      JournalEntryWidget(),
      sectionTitlePadding,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("New Transaction"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Card(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TransactionDatePicker(
                        controller: _transactionDateController),
                    ...debitInputSection,
                    ...creditInputSection,
                    SizedBox(height: 16.0),
                    SizedBox(height: 16.0),
                    TotalAmountView(2500.0),
                    SizedBox(height: 8.0),
                    RaisedButton(
                      onPressed: saveForm,
                      child: Text("Record"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    print("Transaction Date: " + _transactionDateController.text);
  }

  Container dividerWidget(final String title) {
    return Container(
      child: Row(
        children: [
          Text(title),
        ],
      ),
    );
  }
}

class TotalAmountView extends StatelessWidget {
  final double amount;

  const TotalAmountView(this.amount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Amount",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          NumberFormat.decimalPattern().format(amount),
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}

class JournalEntryWidget extends StatelessWidget {
  const JournalEntryWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: AccountNameInput(),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: AmountInput(),
          ),
        ],
      ),
    );
  }
}

class AmountInput extends StatefulWidget {
  @override
  _AmountInputState createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final controller = CurrencyTextFieldController(
    rightSymbol: 'Php ',
    decimalSymbol: '.',
    thousandSymbol: ',',
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Amount",
      ),
      keyboardType: TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      textAlign: TextAlign.end,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Provide amount in transsaction";
        }

        return null;
      },
    );
  }
}

class AccountNameInput extends StatefulWidget {
  @override
  _AccountNameInputState createState() => _AccountNameInputState();
}

class _AccountNameInputState extends State<AccountNameInput> {
  String value;

  @override
  Widget build(BuildContext context) {
    List<String> accountNames = [
      'Cash on Hand',
      'Income',
      'Expense - Personal'
    ];

    return DropdownButtonFormField(
      value: value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Select an account';
        }
        return null;
      },
      isDense: true,
      isExpanded: true,
      hint: Text('Account'),
      items: accountNames
          .map((name) => DropdownMenuItem(
                child: Text(name),
                value: name,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          this.value = value;
        });
      },
    );
  }
}

class TransactionDatePicker extends StatefulWidget {
  final TextEditingController controller;

  const TransactionDatePicker({Key key, this.controller}) : super(key: key);

  @override
  _TransactionDatePickerState createState() => _TransactionDatePickerState();
}

class _TransactionDatePickerState extends State<TransactionDatePicker> {
  final formatter = DateFormat("MMMM dd, y (EEEE)");

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.widget.controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Select a transaction date";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Transaction Date",
      ),
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        this.widget.controller.text = formatter.format(date);
      },
    );
  }
}
