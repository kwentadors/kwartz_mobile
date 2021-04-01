part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class SaveTransaction extends TransactionEvent {}
