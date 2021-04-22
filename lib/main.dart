import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwartz_mobile/utils/router.dart';
import 'modules/transaction/repositories/transaction_repository.dart';
import 'modules/financial_account/blocs/financial_account_bloc.dart';
import 'modules/financial_account/repositories/financial_account_repository.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FinancialAccountRepository>(
            create: (context) => FinancialAccountRepository()),
        RepositoryProvider<TransactionRepository>(
            create: (context) => TransactionRepository()),
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
        child: MaterialApp(
          title: 'Kwartz',
          // darkTheme: ThemeData.dark(),
          theme: ThemeData(
            // brightness: Brightness.dark,
            primaryColor: Colors.pink[400],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: Routes.TransactionList,
          onGenerateRoute: KwartzRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
