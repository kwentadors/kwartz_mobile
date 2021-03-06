import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:kwartz_mobile/providers/new_transaction.dart';
import 'package:provider/provider.dart';

class JournalEntryWidget extends StatelessWidget {
  final CurrencyTextFieldController amountController;

  const JournalEntryWidget({Key key, this.amountController}) : super(key: key);

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
            child: AmountInput(controller: amountController),
          ),
        ],
      ),
    );
  }
}

class AmountInput extends StatefulWidget {
  final CurrencyTextFieldController controller;

  const AmountInput({Key key, this.controller}) : super(key: key);

  @override
  _AmountInputState createState() => _AmountInputState(controller);
}

class _AmountInputState extends State<AmountInput> {
  final CurrencyTextFieldController controller;

  _AmountInputState(this.controller);

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
      onChanged: (value) {
        var trx = Provider.of<NewTransaction>(context, listen: false);
        trx.setDebitAmount(controller.doubleValue);
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
