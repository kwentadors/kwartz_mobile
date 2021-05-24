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
  final String description;

  MockAssetReportGroupEntry({
    this.name = 'Account entry',
    this.amount = 0.00,
    this.changePercent = 0.00,
    this.description,
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

  group("AssetReportGroupEntryTile", () {
    testWidgets('with increase in balance', (tester) async {
      final assetEntry = MockAssetReportGroupEntry(
        name: "House n' Lot",
        amount: 33365.08,
        changePercent: 8.17,
      );

      await tester.pumpWidget(Material(
        child: MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AssetReportGroupEntryTile(entry: assetEntry),
          ),
        ),
      ));

      expect(
          tester.widget(find.text(assetEntry.name)),
          isA<Text>()
              .having((t) => t.style.color, 'title color', Colors.green));
      expect(
          tester.widget(find.text("33,365.08")),
          isA<Text>().having(
              (t) => t.style.color, 'amount balance color', Colors.green));
      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
    });

    testWidgets('with decrease in balance', (tester) async {
      final assetEntry = MockAssetReportGroupEntry(
        name: "Savings Account",
        amount: 552.81,
        changePercent: -0.18,
      );

      await tester.pumpWidget(Material(
        child: MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AssetReportGroupEntryTile(entry: assetEntry),
          ),
        ),
      ));

      expect(tester.widget(find.text(assetEntry.name)),
          isA<Text>().having((t) => t.style.color, 'title color', Colors.red));
      expect(
          tester.widget(find.text("552.81")),
          isA<Text>().having(
              (t) => t.style.color, 'amount balance color', Colors.red));
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('with zero change in balance', (tester) async {
      final assetEntry = MockAssetReportGroupEntry(
        name: "Miscellaneous assets",
        amount: 0.00,
        changePercent: 0.00,
      );

      await tester.pumpWidget(Material(
        child: MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AssetReportGroupEntryTile(entry: assetEntry),
          ),
        ),
      ));

      expect(tester.widget(find.text(assetEntry.name)),
          isA<Text>().having((t) => t.style.color, 'title color', Colors.grey));
      expect(
          tester.widget(find.text("0.00")),
          isA<Text>().having(
              (t) => t.style.color, 'amount balance color', Colors.grey));
      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
    });
  });
}
