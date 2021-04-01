part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionSaving extends TransactionState {}

class TransactionSaveSuccess extends TransactionState {}
