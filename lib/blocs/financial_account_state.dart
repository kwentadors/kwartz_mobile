part of 'financial_account_bloc.dart';

@immutable
abstract class FinancialAccountState {
  final List<FinancialAccount> accounts;

  FinancialAccountState(this.accounts);
}

class PrebootState extends FinancialAccountState {
  PrebootState() : super(List.empty());
}

class ReadyState extends FinancialAccountState {
  ReadyState(List<FinancialAccount> accounts) : super(accounts);
}
