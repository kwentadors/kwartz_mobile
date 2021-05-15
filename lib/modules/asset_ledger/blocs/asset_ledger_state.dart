part of 'asset_ledger_bloc.dart';

abstract class AssetLedgerState extends Equatable {
  const AssetLedgerState();

  @override
  List<Object> get props => [];
}

class AssetLedgerInitial extends AssetLedgerState {}

class AssetLedgerLoading extends AssetLedgerState {}

class AssetLedgerReady extends AssetLedgerState {
  AssetReport get assetReport => AssetReport(
        groups: <AssetReportGroup>[
          AssetReportGroup(
            name: 'Cash equivalents',
            entries: <AssetReportGroupEntry>[
              AssetReportGroupEntry(
                name: 'Savings',
                amount: 20000,
                description: 'XXXXXXXX8025',
              ),
              AssetReportGroupEntry(
                name: 'Petty Cash',
                amount: 7800,
              ),
            ],
          ),
          AssetReportGroup(
            name: 'Property',
            entries: <AssetReportGroupEntry>[
              AssetReportGroupEntry(
                name: 'BLOQ Residences Unit 903',
                amount: 121156.36,
              ),
              AssetReportGroupEntry(
                name: 'BLOQ Residences Unit 904',
                amount: 121156.36,
              ),
              AssetReportGroupEntry(
                name: 'BLOQ Residences Unit 902',
                amount: 73003.70,
              ),
            ],
          )
        ],
      );
}
