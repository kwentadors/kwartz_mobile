part of 'asset_ledger_bloc.dart';

abstract class AssetLedgerEvent extends Equatable {
  const AssetLedgerEvent();

  @override
  List<Object> get props => [];
}

class FetchAssetReport extends AssetLedgerEvent {}
