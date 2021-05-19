import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/asset_ledger/blocs/asset_ledger_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/models/asset_report.dart';
import 'package:kwartz_mobile/modules/asset_ledger/repositories/asset_report_repository.dart';
import 'package:mockito/mockito.dart';

class MockAssetReportRepository extends Mock implements AssetReportRepository {}

void main() {
  AssetReportRepository repository;

  group('AssetLedgerBloc', () {
    AssetReport assetReport;

    setUp(() {
      repository = MockAssetReportRepository();
      assetReport = createAssetReportStub();

      when(repository.fetch()).thenAnswer((_) async => assetReport);
    });

    test('should intialize to AssetLedgerInitial state', () {
      expect(AssetLedgerBloc(repository).state, isA<AssetLedgerInitial>());
    });

    blocTest(
      'emits [AssetLedgerLoading, AssetLedgerReady] during initialization',
      build: () => AssetLedgerBloc(repository),
      expect: [AssetLedgerLoading(), AssetLedgerReady(assetReport)],
    );

    blocTest(
      'emits [AssetLedgerLoading, AssetLedgerReady] when FetchAssetReportState',
      build: () => AssetLedgerBloc(repository)..add(FetchAssetReport()),
      skip: 2,
      expect: [AssetLedgerLoading(), AssetLedgerReady(assetReport)],
    );
  });
}

AssetReport createAssetReportStub() {
  final assetReport = AssetReport(
    groups: <AssetReportGroup>[
      AssetReportGroup(id: '1', name: 'Cash equivalents'),
      AssetReportGroup(id: '2', name: 'Property')
    ],
  );

  assetReport.groups[0].entries.addAll(<AssetReportGroupEntry>[
    AssetReportGroupEntry(
      name: 'Savings',
      amount: 20000,
      changePercent: 0.5,
      description: 'XXXXXXXX8025',
    ),
    AssetReportGroupEntry(
      name: 'Petty Cash',
      changePercent: 1.5,
      amount: 7800,
    ),
  ]);

  assetReport.groups[1].entries.addAll(
    <AssetReportGroupEntry>[
      AssetReportGroupEntry(
        name: 'BLOQ Residences Unit 903',
        amount: 121156.36,
        changePercent: 5.2,
      ),
      AssetReportGroupEntry(
        name: 'BLOQ Residences Unit 904',
        amount: 121156.36,
        changePercent: 5.2,
      ),
      AssetReportGroupEntry(
        name: 'BLOQ Residences Unit 902',
        amount: 73003.70,
        changePercent: 0.3,
      ),
    ],
  );
  return assetReport;
}
