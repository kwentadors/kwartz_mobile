import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'financial_account_event.dart';
part 'financial_account_state.dart';

class FinancialAccountBloc
    extends Bloc<FinancialAccountEvent, FinancialAccountState> {
  FinancialAccountBloc() : super(FinancialAccountInitial());

  @override
  Stream<FinancialAccountState> mapEventToState(
    FinancialAccountEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
