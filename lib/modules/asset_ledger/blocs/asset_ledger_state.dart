part of 'asset_ledger_bloc.dart';

abstract class AssetLedgerState extends Equatable {
  const AssetLedgerState();

  @override
  List<Object> get props => [];
}

class AssetLedgerInitial extends AssetLedgerState {}

class AssetLedgerLoading extends AssetLedgerState {}

class AssetLedgerReady extends AssetLedgerState {
  AssetReport get assetReport => AssetReport(groups: <AssetReportGroup>[]);
}
