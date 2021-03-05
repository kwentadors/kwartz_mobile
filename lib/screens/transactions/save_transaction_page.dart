import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwartz_mobile/molecules/transaction_date_picker.dart';
import '../../molecules/journal_entry.dart';

class SaveTransactionPage extends StatefulWidget {
  @override
  _SaveTransactionPageState createState() => _SaveTransactionPageState();
}

class _SaveTransactionPageState extends State<SaveTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final _transactionDateController = TextEditingController();

  final _debitAmountController = amountFieldController();

  final _creditAmountController = amountFieldController();

  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 16.0);

    var debitInputSection = [
      sectionTitlePadding,
      dividerWidget('Debit'),
      JournalEntryWidget(amountController: _debitAmountController),
      sectionTitlePadding,
    ];

    var creditInputSection = [
      sectionTitlePadding,
      dividerWidget('Credit'),
      JournalEntryWidget(amountController: _creditAmountController),
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
    print("Debit amount: " + _debitAmountController.text);
    print("Credit amount: " + _creditAmountController.text);
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

  static CurrencyTextFieldController amountFieldController() {
    return CurrencyTextFieldController(
      rightSymbol: 'Php ',
      decimalSymbol: '.',
      thousandSymbol: ',',
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
