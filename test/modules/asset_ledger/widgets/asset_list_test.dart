import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/asset_ledger/blocs/asset_ledger_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/models/asset_report.dart';
import 'package:kwartz_mobile/modules/asset_ledger/widgets/asset_list.dart';
import 'package:mockito/mockito.dart';

class MockAssetLedgerBloc extends Mock implements AssetLedgerBloc {}

class MockAssetReport extends Mock implements AssetReport {}

class MockAssetReportGroup extends Mock implements AssetReportGroup {
  final String name;
  final String description;
  final List<AssetReportGroupEntry> entries;

  MockAssetReportGroup({
    this.name = 'name',
    this.description = 'descritpion',
    this.entries = const <AssetReportGroupEntry>[],
  });
}

void main() {
  AssetLedgerBloc _bloc;

  setUp(() {
    _bloc = MockAssetLedgerBloc();
  });

  group("AssetList", () {
    testWidgets("at AssetLedgerInitial state", (tester) async {
      when(_bloc.state).thenReturn(AssetLedgerInitial());

      await tester.pumpWidget(BlocProvider<AssetLedgerBloc>(
        create: (context) => _bloc,
        child: AssetList(),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("at AssetLedgerLoading state", (tester) async {
      when(_bloc.state).thenReturn(AssetLedgerLoading());

      await tester.pumpWidget(BlocProvider<AssetLedgerBloc>(
        create: (context) => _bloc,
        child: AssetList(),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    MockAssetReport _mockAssetReport() {
      final assetReport = MockAssetReport();
      when(assetReport.groups).thenReturn([
        MockAssetReportGroup(),
        MockAssetReportGroup(),
        MockAssetReportGroup(),
      ]);

      return assetReport;
    }

    testWidgets("at AssetLedgerReady state", (tester) async {
      final assetReport = _mockAssetReport();
      when(_bloc.state).thenReturn(AssetLedgerReady(assetReport));

      await tester.pumpWidget(BlocProvider<AssetLedgerBloc>(
        create: (context) => _bloc,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AssetList(),
        ),
      ));

      expect(
          tester.widget(find.byKey(ValueKey('asset-group-list'))),
          isA<ListView>().having(
              (listView) => listView.childrenDelegate.estimatedChildCount,
              "number of children",
              5));

      expect(find.byType(AssetGroupTile), findsNWidgets(3));
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });
}
