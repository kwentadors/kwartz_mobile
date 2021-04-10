import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/transaction_bloc.dart';
import '../../molecules/amount_section.dart';
import '../../molecules/transaction_date_picker.dart';
import '../../molecules/journal_entry.dart';

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
