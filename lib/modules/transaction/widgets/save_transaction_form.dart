import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'journal_entry_components.dart';
import '../blocs/transaction_bloc.dart';
import '../../../utils/ui/date_picker.dart';

class SaveTransactionForm extends StatefulWidget {
  const SaveTransactionForm({Key key}) : super(key: key);

  @override
  _SaveTransactionFormState createState() => _SaveTransactionFormState();
}

class _SaveTransactionFormState extends State<SaveTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                  actionButtons(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RaisedButton actionButtons(BuildContext context) {
    // ignore: close_sinks
    var transactionBloc = context.read<TransactionBloc>();
    if (transactionBloc.state is TransactionSaving) {
      return RaisedButton(
        child: Text("Saving..."),
      );
    }

    if (transactionBloc.state is TransactionSaveSuccess) {
      return RaisedButton(
        onPressed: () {
          transactionBloc.add(ResetTransaction());
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("TODO:New trnsaction, it is!")));
        },
        child: Text("New Transaction"),
      );
    }

    return RaisedButton(
      onPressed: () {
        var transaction = transactionBloc.state.transaction;
        if (!_formKey.currentState.validate()) return;
        _formKey.currentState.save();
        context.read<TransactionBloc>().add(SaveTransaction(transaction));
      },
      child: InkWell(child: Text("Record")),
    );
  }
}

class TransactionDatePicker extends StatefulWidget {
  const TransactionDatePicker({Key key}) : super(key: key);

  @override
  _TransactionDatePickerState createState() => _TransactionDatePickerState();
}

class _TransactionDatePickerState extends State<TransactionDatePicker> {
  @override
  Widget build(BuildContext context) {
    var transaction =
        BlocProvider.of<TransactionBloc>(context).state.transaction;

    return DatePicker(
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
