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

  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 20.0);
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
                    transactionDateInput(),
                    sectionTitlePadding,
                    dividerWidget('Debit'),
                    JournalEntryWidget(),
                    sectionTitlePadding,
                    dividerWidget('Credit'),
                    JournalEntryWidget(),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          "2,500.75",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
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

  Widget transactionDateInput() {
    return TransactionDatePicker();
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

    return DropdownButton(
      value: value,
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
  @override
  _TransactionDatePickerState createState() => _TransactionDatePickerState();
}

class _TransactionDatePickerState extends State<TransactionDatePicker> {
  final controller = TextEditingController();
  final formatter = DateFormat("MMMM dd, y (EEEE)");

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
        controller.text = formatter.format(date);
      },
    );
  }
}
