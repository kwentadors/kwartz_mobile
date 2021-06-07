import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../financial_account/blocs/financial_account_bloc.dart';
import '../blocs/transaction_bloc.dart';
import '../models/transaction.dart';

class DebitSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    var transactionBloc = BlocProvider.of<TransactionBloc>(context);
    var transaction = transactionBloc.state.transaction;

    return TransactionSideSection(
      sectionTitle: 'Debit',
      entries: transaction.debitEntries,
      onAddEntry: () => transactionBloc.add(AddDebitEntryEvent()),
    );
  }
}

class CreditSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    var transactionBloc = BlocProvider.of<TransactionBloc>(context);
    var transaction = transactionBloc.state.transaction;

    return TransactionSideSection(
      sectionTitle: "Credit",
      entries: transaction.creditEntries,
      onAddEntry: () => transactionBloc.add(AddCreditEntryEvent()),
    );
  }
}

class TransactionSideSection extends StatelessWidget {
  final String sectionTitle;
  final List<JournalEntry> entries;
  final void Function() onAddEntry;

  const TransactionSideSection({
    Key key,
    @required this.sectionTitle,
    @required this.entries,
    this.onAddEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 16.0);
    return Column(
      children: [
        sectionTitlePadding,
        sectionHeader(),
        ...entries.asMap().entries.map((entry) => JournalEntryWidget(
              key: ValueKey(entry.key),
              entry: entry.value,
            )),
        addEntrySection(),
        sectionTitlePadding,
      ],
    );
  }

  Container sectionHeader() {
    return Container(
      child: Row(
        children: [
          Text(sectionTitle),
        ],
      ),
    );
  }

  Container addEntrySection() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton.icon(
        icon: Icon(Icons.add),
        onPressed: onAddEntry,
        label: Text("$sectionTitle entry"),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
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
    return BlocBuilder<FinancialAccountBloc, FinancialAccountState>(
      builder: (context, state) {
        if (state is PrebootState) {
          context.read<FinancialAccountBloc>().add(BootEvent());
          return Center(child: CircularProgressIndicator());
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
