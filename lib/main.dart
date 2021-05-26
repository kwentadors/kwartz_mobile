import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/serializers/asset_report_serializer.dart';
import 'modules/asset_ledger/repositories/asset_report_repository.dart';
import 'utils/router.dart';
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
        RepositoryProvider(
          create: (context) => AssetReportRepository(
            serializer: AssetReportSerializer(),
          ),
        )
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
          theme: ThemeData(
            colorScheme: ColorScheme(
              primary: Colors.grey[900],
              primaryVariant: Colors.black,
              onPrimary: Colors.white,
              secondary: Colors.brown[400],
              secondaryVariant: Colors.brown,
              onSecondary: Colors.white,
              surface: Colors.grey[100],
              onSurface: Colors.white,
              background: Colors.grey[200],
              onBackground: Colors.white,
              error: Colors.red,
              onError: Colors.red,
              brightness: Brightness.light,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: Routes.LedgerList,
          onGenerateRoute: KwartzRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
