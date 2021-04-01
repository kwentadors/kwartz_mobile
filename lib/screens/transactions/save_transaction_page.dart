import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../bloc/transaction_bloc.dart';
import '../../molecules/amount_section.dart';
import '../../providers/new_transaction.dart';
import '../../molecules/transaction_date_picker.dart';
import '../../molecules/journal_entry.dart';

class SaveTransactionPage extends StatefulWidget {
  @override
  _SaveTransactionPageState createState() => _SaveTransactionPageState();
}

class _SaveTransactionPageState extends State<SaveTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _transactionDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Transaction"),
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          print("Listened to state: " + state.toString());
          if (state is TransactionSaveSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text("Successfully saved transaction")));
          }
        },
        builder: (context, state) {
          print("Built state: " + state.toString());
          if (state is TransactionSaving) {
            return loadingForm();
          }
          return buildForm();
        },
      ),
    );
  }

  Container loadingForm() {
    return Container(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(),
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
              child: ChangeNotifierProvider<NewTransaction>(
                  create: (_) => NewTransaction.create(),
                  builder: (context, _) {
                    return Column(
                      children: <Widget>[
                        TransactionDatePicker(
                            controller: _transactionDateController),
                        DebitSection(),
                        CreditSection(),
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                        TotalAmountSection(
                            debitAmount: 2500.0, creditAmount: 2500.00),
                        SizedBox(height: 8.0),
                        RaisedButton(
                          onPressed: () => saveForm(context),
                          child: Text("Record"),
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void saveForm(BuildContext context) {
    // if (!_formKey.currentState.validate()) {
    //   return;
    // }

    // _formKey.currentState.save();

    // var trx = Provider.of<NewTransaction>(context, listen: false);
    // print(trx.toString());

    // print("Transaction Date: " + trx.transactionDate.toIso8601String());
    // print("Debit debitAmount: " + trx.debitAmount.toString());
    // print("Credit debitAmount: " + trx.creditAmount.toString());

    BlocProvider.of<TransactionBloc>(context).add(SaveTransaction());
  }
}

class DebitSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 16.0);

    return Consumer<NewTransaction>(
      builder: (context, trx, child) {
        return Column(
          children: [
            sectionTitlePadding,
            SectionTitle('Debit'),
            ...(trx.debitEntries
                .asMap()
                .entries
                .map((entry) => JournalEntryWidget(
                      key: ValueKey("CR-${entry.key}"),
                      entry: entry.value,
                    ))).toList(),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton.icon(
                icon: Icon(Icons.add),
                onPressed: () {
                  trx.createDebitEntry();
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

    return Consumer<NewTransaction>(
      builder: (context, transaction, _) => Column(
        children: [
          sectionTitlePadding,
          SectionTitle('Credit'),
          ...transaction.creditEntries
              .asMap()
              .entries
              .map((entry) => JournalEntryWidget(
                    key: ValueKey("CR-${entry.key}"),
                    entry: entry.value,
                  )),
          Container(
            alignment: Alignment.centerRight,
            child: FlatButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                transaction.createCreditEntry();
              },
              label: Text("Add credit entry"),
            ),
          ),
          sectionTitlePadding,
        ],
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
