import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'income_expense_event.dart';
part 'income_expense_state.dart';

class IncomeExpenseBloc extends Bloc<IncomeExpenseEvent, IncomeExpenseState> {
  IncomeExpenseBloc() : super(IncomeExpenseReady());

  @override
  Stream<IncomeExpenseState> mapEventToState(
    IncomeExpenseEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
