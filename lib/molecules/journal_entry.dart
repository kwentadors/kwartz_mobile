import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'journal_entry_account.dart';
import '../blocs/transaction_bloc.dart';
import '../models/transaction.dart';

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
  final JournalEntry entry;
  const AmountInput({Key key, @required this.entry}) : super(key: key);

  @override
  _AmountInputState createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final TextEditingController controller = TextEditingController();

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
        var journalEntry =
            this.widget.entry.copyWith(amount: double.parse(value));
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
  }
}
