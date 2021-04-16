import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kwartz_mobile/modules/transaction/models/transaction.dart';
import '../repositories/financial_account_repository.dart';
import 'package:meta/meta.dart';

part 'financial_account_event.dart';
part 'financial_account_state.dart';

class FinancialAccountBloc
    extends Bloc<FinancialAccountEvent, FinancialAccountState> {
  final FinancialAccountRepository _financialAccountRepository;

  FinancialAccountBloc(this._financialAccountRepository)
      : super(PrebootState());

  @override
  Stream<FinancialAccountState> mapEventToState(
    FinancialAccountEvent event,
  ) async* {
    var accounts = await _financialAccountRepository.getAll();
    yield ReadyState(List.unmodifiable(accounts));
  }
}
