import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:kwartz_mobile/blocs/financial_account_bloc.dart';
import '../blocs/transaction_bloc.dart';
import '../models/transaction.dart';

class AccountNameInput extends StatefulWidget {
  final JournalEntry entry;

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

    return BlocBuilder<FinancialAccountBloc, FinancialAccountState>(
      builder: (context, state) {
        if (state is PrebootState) {
          BlocProvider.of<FinancialAccountBloc>(context).add(BootEvent());
          // return CircularProgressIndicator();
          return Text("Loading...");
        }
        return DropdownButtonFormField<FinancialAccount>(
          value: this.widget.entry?.account,
          validator: (value) {
            if (value == null) {
              return 'Select an account';
            }
            return null;
          },
          isDense: true,
          isExpanded: true,
          hint: Text('Account'),
          items: state.accounts
              .map((account) => DropdownMenuItem(
                    child: Text(account?.name ?? "Empty"),
                    value: account,
                  ))
              .toList(),
          onChanged: (value) {
            var journalEntry = this.widget.entry.copyWith(account: value);
            var journalEntryIndex = (this.widget.key as ValueKey).value;
            if (journalEntry.type == JournalEntryType.DEBIT) {
              BlocProvider.of<TransactionBloc>(context)
                  .add(UpdateDebitEntry(journalEntryIndex, journalEntry));
            } else {
              BlocProvider.of<TransactionBloc>(context)
                  .add(UpdateCreditEntry(journalEntryIndex, journalEntry));
            }
          },
        );
      },
    );
  }
}
