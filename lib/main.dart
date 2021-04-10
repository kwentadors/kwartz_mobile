import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import './blocs/transaction_bloc.dart';
import './screens/transactions/save_transaction_page.dart';

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
      home: BlocProvider(
        create: (BuildContext context) => TransactionBloc(),
        child: SaveTransactionPage(),
      ),
    );
  }
}
