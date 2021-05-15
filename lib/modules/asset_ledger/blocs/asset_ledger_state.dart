part of 'asset_ledger_bloc.dart';

abstract class AssetLedgerState extends Equatable {
  const AssetLedgerState();

  @override
  List<Object> get props => [];
}

class AssetLedgerInitial extends AssetLedgerState {}

class AssetLedgerLoading extends AssetLedgerState {}

class AssetLedgerReady extends AssetLedgerState {
  double get balance => 523720.72;
  double get changePercent => -2.45;
}
