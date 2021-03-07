import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../providers/new_transaction.dart';
import 'package:provider/provider.dart';

class JournalEntryWidget extends StatelessWidget {
  final JournalEntry entry;

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
              entry.account,
              key: key,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: AmountInput(key: key),
          ),
        ],
      ),
    );
  }
}

class AmountInput extends StatefulWidget {
  const AmountInput({Key key}) : super(key: key);

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
      onChanged: (value) {
        var transaction = Provider.of<NewTransaction>(context, listen: false);
        var entryIndex = (this.widget.key as ValueKey<int>).value;
        var journalEntry = transaction.getDebitEntryAt(entryIndex);
        journalEntry.amount = controller.doubleValue;
        transaction.setDebitEntryAt(entryIndex, journalEntry);
      },
    );
  }
}

class AccountNameInput extends StatefulWidget {
  final FinancialAccount account;

  const AccountNameInput(this.account, {Key key}) : super(key: key);

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
      value: value,
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
        var transaction = Provider.of<NewTransaction>(context, listen: false);
        var entryIndex = (this.widget.key as ValueKey<int>).value;
        var journalEntry = transaction.getDebitEntryAt(entryIndex);
        journalEntry.account = value;
        transaction.setDebitEntryAt(entryIndex, journalEntry);
      },
    );
  }
}
