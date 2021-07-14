import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:flutter_bloc/src/repository_provider.dart';
import 'modules/asset_ledger/blocs/asset_ledger_bloc.dart';
import 'modules/asset_ledger/blocs/income_expense_bloc.dart';
import 'modules/asset_ledger/repositories/income_expense_repository.dart';
import 'modules/asset_ledger/serializers/asset_report_serializer.dart';
import 'modules/transaction/blocs/list_transaction_bloc.dart';
import 'modules/asset_ledger/repositories/asset_report_repository.dart';
import 'utils/router.dart';
import 'modules/transaction/repositories/transaction_repository.dart';
import 'modules/financial_account/blocs/financial_account_bloc.dart';
import 'modules/financial_account/repositories/financial_account_repository.dart';
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
      providers: _fetchRepositories(),
      child: MultiBlocProvider(
        providers: _fetchBlocs(),
        child: MaterialApp(
          title: 'Kwartz',
          theme: ThemeData(
            colorScheme: ColorScheme(
              primary: Colors.grey[900],
              primaryVariant: Colors.black,
              onPrimary: Colors.white,
              secondary: Colors.brown[400],
              secondaryVariant: Colors.brown,
              onSecondary: Colors.white,
              surface: Colors.grey[100],
              onSurface: Colors.black,
              background: Colors.grey[200],
              onBackground: Colors.black,
              error: Colors.red,
              onError: Colors.red,
              brightness: Brightness.light,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.brown[400],
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: Routes.LedgerList,
          onGenerateRoute: KwartzRouter.onGenerateRoute,
        ),
      ),
    );
  }

  List<RepositoryProviderSingleChildWidget> _fetchRepositories() {
    return [
      RepositoryProvider<FinancialAccountRepository>(
          create: (context) => FinancialAccountRepository()),
      RepositoryProvider<TransactionRepository>(
          create: (context) => TransactionRepository()),
      RepositoryProvider(
        create: (context) => AssetReportRepository(
          serializer: AssetReportSerializer(),
        ),
      )
    ];
  }

  List<BlocProviderSingleChildWidget> _fetchBlocs() {
    return [
      BlocProvider<FinancialAccountBloc>(
        create: (context) =>
            FinancialAccountBloc(context.read<FinancialAccountRepository>()),
      ),
      BlocProvider<ListTransactionBloc>(
        create: (context) =>
            ListTransactionBloc(context.read<TransactionRepository>()),
      ),
      BlocProvider<AssetLedgerBloc>(
        create: (context) =>
            AssetLedgerBloc(context.read<AssetReportRepository>()),
      ),
      BlocProvider<IncomeExpenseBloc>(
        create: (context) => IncomeExpenseBloc(IncomeExpenseRepository()),
      )
    ];
  }
}
