import 'dart:async';

import 'package:bloc/bloc.dart';
import '../repositories/financial_account_repository.dart';
import '../models/transaction.dart';
import 'package:meta/meta.dart';

part 'financial_account_event.dart';
part 'financial_account_state.dart';

class FinancialAccountBloc
    extends Bloc<FinancialAccountEvent, FinancialAccountState> {
  final _financialAccountRepository = FinancialAccountRepository();
  List<FinancialAccount> accounts;

  FinancialAccountBloc() : super(PrebootState());

  void boot() {
    add(BootEvent());
  }

  @override
  Stream<FinancialAccountState> mapEventToState(
    FinancialAccountEvent event,
  ) async* {
    if (event is BootState) {
      accounts =
          List.unmodifiable(await _financialAccountRepository.fetchAll());
      yield ReadyState();
    }
  }
}
