import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import '../../molecules/amount_section.dart';
import '../../providers/new_transaction.dart';
import 'package:provider/provider.dart';
import '../../molecules/transaction_date_picker.dart';
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
