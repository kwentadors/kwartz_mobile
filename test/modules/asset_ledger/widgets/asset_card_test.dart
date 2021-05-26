import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/asset_ledger/blocs/asset_ledger_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/models/asset_report.dart';
import 'package:kwartz_mobile/modules/asset_ledger/widgets/asset_card.dart';
import 'package:mockito/mockito.dart';

class MockAssetLedgerBloc extends Mock implements AssetLedgerBloc {}

class MockAssetReport extends Mock implements AssetReport {}

void main() {
  AssetLedgerBloc _bloc;

  setUp(() {
    _bloc = MockAssetLedgerBloc();
  });

  tearDown(() {
    if (_bloc != null) _bloc.close();
  });

  group('AssetCard', () {
    testWidgets('should initially render progress indicator', (tester) async {
      when(_bloc.state).thenReturn(AssetLedgerInitial());

      await tester.pumpWidget(
        BlocProvider<AssetLedgerBloc>(
          create: (context) => _bloc,
          child: AssetsCard(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should render progress indicator when state is loading',
        (tester) async {
      when(_bloc.state).thenReturn(AssetLedgerLoading());

      await tester.pumpWidget(
        BlocProvider<AssetLedgerBloc>(
          create: (context) => _bloc,
          child: AssetsCard(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    group('at AssetLedgerReadyState', () {
      AssetReport assetReport;

      setUp(() {
        assetReport = MockAssetReport();
        when(_bloc.state).thenReturn(AssetLedgerReady(assetReport));
      });

      testWidgets('with decrease in asset', (tester) async {
        when(assetReport.balance).thenReturn(120025.17);
        when(assetReport.changePercent).thenReturn(-5.23);

        await tester.pumpWidget(BlocProvider<AssetLedgerBloc>(
          create: (context) => _bloc,
          child: AssetsCard(),
        ));

        expect(
          tester.widget(find.byKey(ValueKey('asset-balance'))),
          isA<Text>()
              .having((t) => t.data, 'text', "120,025.17")
              .having((t) => t.style.color, 'text color', Colors.redAccent),
        );

        expect(
          tester.widget(find.byKey(ValueKey('asset-change'))),
          isA<Text>()
              .having((t) => t.data, 'text', "5.23%")
              .having((t) => t.style.color, 'text color', Colors.redAccent),
        );

        expect(
            tester.widget(find.byKey(ValueKey("asset-change-icon"))),
            isA<Icon>()
                .having((i) => i.icon, 'icon', Icons.arrow_drop_down)
                .having((i) => i.color, 'icon color', Colors.redAccent));
      });

      testWidgets('with increase in asset', (tester) async {
        when(assetReport.balance).thenReturn(523720.72);
        when(assetReport.changePercent).thenReturn(2.23);

        await tester.pumpWidget(BlocProvider<AssetLedgerBloc>(
          create: (context) => _bloc,
          child: AssetsCard(),
        ));

        expect(
          tester.widget(find.byKey(ValueKey('asset-balance'))),
          isA<Text>()
              .having((t) => t.data, 'text', "523,720.72")
              .having((t) => t.style.color, 'text color', Colors.greenAccent),
        );

        expect(
          tester.widget(find.byKey(ValueKey('asset-change'))),
          isA<Text>()
              .having((t) => t.data, 'text', "2.23%")
              .having((t) => t.style.color, 'text color', Colors.greenAccent),
        );

        expect(
            tester.widget(find.byKey(ValueKey("asset-change-icon"))),
            isA<Icon>()
                .having((i) => i.icon, 'icon', Icons.arrow_drop_up)
                .having((i) => i.color, 'icon color', Colors.greenAccent));
      });

      testWidgets('with zero change in asset', (tester) async {
        when(assetReport.balance).thenReturn(36855.70);
        when(assetReport.changePercent).thenReturn(0);

        await tester.pumpWidget(BlocProvider<AssetLedgerBloc>(
          create: (context) => _bloc,
          child: AssetsCard(),
        ));

        expect(
          tester.widget(find.byKey(ValueKey('asset-balance'))),
          isA<Text>()
              .having((t) => t.data, 'text', "36,855.70")
              .having((t) => t.style.color, 'text color', Colors.grey),
        );

        expect(
          tester.widget(find.byKey(ValueKey('asset-change'))),
          isA<Text>()
              .having((t) => t.data, 'text', "0.00%")
              .having((t) => t.style.color, 'text color', Colors.grey),
        );

        expect(find.byKey(ValueKey("asset-change-icon")), findsNothing);
      });
    });
  });
}
