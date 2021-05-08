import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../financial_account/blocs/financial_account_bloc.dart';
import '../../../utils/ui/date_picker.dart';
import '../models/transaction.dart';
import '../blocs/transaction_bloc.dart';

class SaveTransactionPage extends StatefulWidget {
  @override
  _SaveTransactionPageState createState() => _SaveTransactionPageState();
}

class _SaveTransactionPageState extends State<SaveTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Transaction"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSaveSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text("Successfully saved transaction")));
          } else if (state is TransactionSaveError) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Something went wrong!")));
          } else if (state is TransactionSaveSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Successfully saved!")));
          }
        },
        builder: (context, state) {
          if (state is TransactionSaving) {
            return loadingForm();
          }
          return buildForm();
        },
      ),
    );
  }

  Widget loadingForm() {
    return Center(
      child: Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildForm() {
    return Container(
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
                  TransactionDatePicker(),
                  DebitSection(),
                  CreditSection(),
                  SizedBox(height: 16.0),
                  SizedBox(height: 16.0),
                  TotalAmountSection(),
                  SizedBox(height: 8.0),
                  RaisedButton(
                    onPressed: () => saveForm(context),
                    child: Text("Record"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveForm(BuildContext context) {
    // TODO validation
    // if (!_formKey.currentState.validate()) {
    //   return;
    // }

    // _formKey.currentState.save();

    var transactionBloc = BlocProvider.of<TransactionBloc>(context);
    var transaction = transactionBloc.state.transaction;
    transactionBloc.add(SaveTransaction(transaction));
  }
}

class DebitSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 16.0);

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        var trx = state.transaction;
        return Column(
          children: [
            sectionTitlePadding,
            SectionTitle('Debit'),
            ...(trx.debitEntries
                .asMap()
                .entries
                .map((entry) => JournalEntryWidget(
                      key: ValueKey(entry.key),
                      entry: entry.value,
                    ))).toList(),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton.icon(
                icon: Icon(Icons.add),
                onPressed: () {
                  BlocProvider.of<TransactionBloc>(context)
                      .add(AddDebitEntryEvent());
                },
                label: Text("Add debit entry"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CreditSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 16.0);
    var transaction =
        BlocProvider.of<TransactionBloc>(context).state.transaction;

    return Column(
      children: [
        sectionTitlePadding,
        SectionTitle('Credit'),
        ...transaction.creditEntries
            .asMap()
            .entries
            .map((entry) => JournalEntryWidget(
                  key: ValueKey(entry.key),
                  entry: entry.value,
                )),
        Container(
          alignment: Alignment.centerRight,
          child: FlatButton.icon(
            icon: Icon(Icons.add),
            onPressed: () {
              BlocProvider.of<TransactionBloc>(context)
                  .add(AddCreditEntryEvent());
            },
            label: Text("Add credit entry"),
          ),
        ),
        sectionTitlePadding,
      ],
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

class TransactionDatePicker extends StatefulWidget {
  const TransactionDatePicker({Key key}) : super(key: key);

  @override
  _TransactionDatePickerState createState() => _TransactionDatePickerState();
}

class _TransactionDatePickerState extends State<TransactionDatePicker> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var transaction =
        BlocProvider.of<TransactionBloc>(context).state.transaction;

    var formatter = DateFormat("MMMM dd, y (EEEE)");
    controller.text = formatter.format(transaction.transactionDate);

    return DatePicker(
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Select a transaction date";
        }
        return null;
      },
      labelText: "Transaction Date",
      initialDate: transaction.transactionDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365)),
      formatter: formatter,
      onChanged: (value) {
        BlocProvider.of<TransactionBloc>(context)
            .add(UpdateTransactionDate(value));
      },
    );
  }
}

class TotalAmountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        var transaction = state.transaction;
        if (transaction.debitAmount == 0 || transaction.creditAmount == 0) {
          return Row();
        }

        if (transaction.debitAmount != transaction.creditAmount) {
          return errorView(context);
        }

        return textAmountView(context, transaction.debitAmount);
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
          NumberFormat.simpleCurrency(decimalDigits: 2, name: "Php ")
              .format(amount),
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
