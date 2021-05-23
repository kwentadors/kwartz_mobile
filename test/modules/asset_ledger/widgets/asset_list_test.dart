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

class MockAssetReportGroupEntry extends Mock implements AssetReportGroupEntry {
  final String name;
  final double amount;
  final double changePercent;

  MockAssetReportGroupEntry({
    this.name = 'Account entry',
    this.amount = 0.00,
    this.changePercent = 0.00,
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

  group("AssetGroupTile", () {
    testWidgets('shows name of asset group', (tester) async {
      final assetReportGroup = MockAssetReportGroup(name: 'Cash equivalents');

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AssetGroupTile(assetReportGroup: assetReportGroup),
        ),
      );

      expect(find.text(assetReportGroup.name), findsOneWidget);
    });

    testWidgets('shows entries under group', (tester) async {
      final assetEntries = [
        MockAssetReportGroupEntry(),
        MockAssetReportGroupEntry(),
        MockAssetReportGroupEntry(),
      ];
      final assetReportGroup = MockAssetReportGroup(entries: assetEntries);

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AssetGroupTile(assetReportGroup: assetReportGroup),
          ),
        ),
      );

      expect(
          tester.widget(find.byType(ListView)),
          isA<ListView>().having(
              (listView) => listView.childrenDelegate.estimatedChildCount,
              'entries count',
              5));
      expect(find.byType(AssetReportGroupEntryTile), findsNWidgets(3));
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });
}
