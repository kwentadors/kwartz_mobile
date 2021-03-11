import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../providers/new_transaction.dart';

class JournalEntryWidget extends StatelessWidget {
  final JournalEntryProvider entry;

  const JournalEntryWidget({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: AccountNameInput(
              key: key,
              entry: entry,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: AmountInput(
              key: key,
              entry: entry,
            ),
          ),
        ],
      ),
    );
  }
}

class AmountInput extends StatefulWidget {
  final JournalEntryProvider entry;
  const AmountInput({Key key, @required this.entry}) : super(key: key);

  @override
  _AmountInputState createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final CurrencyTextFieldController controller = CurrencyTextFieldController(
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
      onChanged: (_) {
        this.widget.entry.setAmount(controller.doubleValue);
      },
    );
  }
}

class AccountNameInput extends StatefulWidget {
  final JournalEntryProvider entry;

  const AccountNameInput({Key key, @required this.entry}) : super(key: key);

  @override
  _AccountNameInputState createState() => _AccountNameInputState();
}

class _AccountNameInputState extends State<AccountNameInput> {
  FinancialAccount value;

  @override
  Widget build(BuildContext context) {
    List<FinancialAccount> accounts = [
      FinancialAccount('Cash on Hand'),
      FinancialAccount('Income'),
      FinancialAccount('Expense - Personal')
    ];

    return DropdownButtonFormField<FinancialAccount>(
      value: this.widget.entry.account,
      validator: (value) {
        if (value == null) {
          return 'Select an account';
        }
        return null;
      },
      isDense: true,
      isExpanded: true,
      hint: Text('Account'),
      items: accounts
          .map((account) => DropdownMenuItem(
                child: Text(account.name),
                value: account,
              ))
          .toList(),
      onChanged: (value) {
        this.widget.entry.setAccount(value);
      },
    );
  }
}
