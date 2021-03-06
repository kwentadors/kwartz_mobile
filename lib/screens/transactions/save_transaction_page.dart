import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwartz_mobile/providers/new_transaction.dart';
import 'package:provider/provider.dart';
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
                child: ChangeNotifierProvider(
                  create: (_) => NewTransaction(),
                  child: Column(
                    children: <Widget>[
                      TransactionDatePicker(
                          controller: _transactionDateController),
                      ...debitInputSection,
                      ...creditInputSection,
                      SizedBox(height: 16.0),
                      SizedBox(height: 16.0),
                      TotalAmountSection(
                          debitAmount: 2500.0, creditAmount: 2500.00),
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
      ),
    );
  }

  void saveForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    print("Transaction Date: " + _transactionDateController.text);
    print("Debit debitAmount: " + _debitAmountController.text);
    print("Credit debitAmount: " + _creditAmountController.text);
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

class TotalAmountSection extends StatelessWidget {
  final double debitAmount;
  final double creditAmount;

  const TotalAmountSection({this.debitAmount, this.creditAmount});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTransaction>(
      builder: (context, transaction, child) {
        print("Consumer: " + transaction.debitAmount.toString());
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
