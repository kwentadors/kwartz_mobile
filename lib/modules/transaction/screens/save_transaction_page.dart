import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/save_transaction_form.dart';
import '../blocs/transaction_bloc.dart';

class SaveTransactionPage extends StatefulWidget {
  @override
  _SaveTransactionPageState createState() => _SaveTransactionPageState();
}

class _SaveTransactionPageState extends State<SaveTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => TransactionBloc(),
      child: Scaffold(
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
                ..showSnackBar(
                    SnackBar(content: Text("Something went wrong!")));
            } else if (state is TransactionSaveSuccess) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text("Sucessfully saved!")));
            }
          },
          builder: (context, state) => SaveTransactionForm(),
        ),
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
}
