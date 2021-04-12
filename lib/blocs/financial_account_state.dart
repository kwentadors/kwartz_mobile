part of 'financial_account_bloc.dart';

@immutable
abstract class FinancialAccountState extends Equatable {
  final List<FinancialAccount> accounts;

  const FinancialAccountState(this.accounts);
}

class PrebootState extends FinancialAccountState {
  const PrebootState() : super(const <FinancialAccount>[]);

  @override
  List<Object> get props => [];
}

class ReadyState extends FinancialAccountState {
  const ReadyState(List<FinancialAccount> accounts) : super(accounts);

  @override
  List<Object> get props => [accounts];
}
