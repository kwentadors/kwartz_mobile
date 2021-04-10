part of 'financial_account_bloc.dart';

@immutable
abstract class FinancialAccountState {}

class FinancialAccountInitial extends FinancialAccountState {}

class PrebootState extends FinancialAccountState {}

class BootState extends FinancialAccountState {}

class ReadyState extends FinancialAccountState {}
