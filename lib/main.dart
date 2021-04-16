import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/financial_account/blocs/financial_account_bloc.dart';
import 'modules/financial_account/repositories/financial_account_repository.dart';
import 'modules/transaction/screens/list_transaction_page.dart';
import 'modules/transaction/screens/save_transaction_page.dart';
import 'modules/transaction/blocs/transaction_bloc.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kwartz',
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: Colors.pink[400],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<FinancialAccountRepository>(
                create: (context) => FinancialAccountRepository())
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TransactionBloc>(
                create: (context) => TransactionBloc(),
              ),
              BlocProvider<FinancialAccountBloc>(
                create: (context) => FinancialAccountBloc(
                    context.read<FinancialAccountRepository>()),
              )
            ],
            child: SaveTransactionPage(),
          )),
    );
  }
}
