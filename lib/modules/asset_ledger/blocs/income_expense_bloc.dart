import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kwartz_mobile/modules/asset_ledger/models/income_expense_report.dart';

part 'income_expense_event.dart';
part 'income_expense_state.dart';

class IncomeExpenseBloc extends Bloc<IncomeExpenseEvent, IncomeExpenseState> {
  IncomeExpenseBloc() : super(IncomeExpenseInitial()) {
    add(FetchIncomeExpenseReport());
  }

  @override
  Stream<IncomeExpenseState> mapEventToState(
    IncomeExpenseEvent event,
  ) async* {
    if (event is FetchIncomeExpenseReport) {
      await Future.delayed(Duration(seconds: 2));
      yield IncomeExpenseReady();
    }
  }
}
