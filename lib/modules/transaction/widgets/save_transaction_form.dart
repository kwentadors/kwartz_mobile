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
    var transaction = context.read<TransactionBloc>().state.transaction;
    context.read<TransactionBloc>().add(SaveTransaction(transaction));
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
