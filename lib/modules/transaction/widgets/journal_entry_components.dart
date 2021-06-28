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
              index: entry.key,
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

class JournalEntryWidget extends StatelessWidget {
  final JournalEntry entry;
  final int index;

  const JournalEntryWidget({Key key, this.entry, this.index}) : super(key: key);

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
              index: index,
              entry: entry,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: AmountInput(
              key: ValueKey(DateTime.now().millisecondsSinceEpoch),
              index: index,
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
  final int index;

  AmountInput({Key key, @required this.entry, this.index}) : super(key: key);

  @override
  AmountInputState createState() => AmountInputState();
}

class AmountInputState extends State<AmountInput> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var amount = this.widget.entry.amount;
    var hasDecimal = (amount * 10) % 10 > 0;
    controller.text = (hasDecimal ? amount : amount.toInt()).toString();

    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: () => controller.selection = TextSelection(
          baseOffset: 0, extentOffset: controller.value.text.length),
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
      onChanged: (value) => this.widget.entry.amount = double.parse(value),
    );
  }
}

class AccountNameInput extends StatefulWidget {
  final JournalEntry entry;
  final int index;

  const AccountNameInput({Key key, @required this.entry, this.index})
      : super(key: key);

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
          onChanged: (value) => this.widget.entry.account = value,
        );
      },
    );
  }
}
