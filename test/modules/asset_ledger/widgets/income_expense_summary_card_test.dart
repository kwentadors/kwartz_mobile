import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/asset_ledger/blocs/income_expense_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/widgets/income_expense_summary_card.dart';
import 'package:mockito/mockito.dart';

class MockIncomeExpenseBloc extends Mock implements IncomeExpenseBloc {}

// ignore: must_be_immutable
class MockIncomeExpenseReady extends Mock implements IncomeExpenseReady {}

class MockChartMetadata extends Mock implements IncomeExpenseChartMetadata {}

void main() {
  IncomeExpenseBloc _bloc;

  setUp(() {
    _bloc = MockIncomeExpenseBloc();
  });

  tearDown(() {
    if (_bloc != null) _bloc.close();
  });

  Widget _widgetWrapper(IncomeExpenseSummaryCard widget) {
    return BlocProvider<IncomeExpenseBloc>(
      create: (context) => _bloc,
      child: MediaQuery(
        data: MediaQueryData(),
        child: Directionality(
          child: widget,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }

  group('Income Expense Summary Card', () {
    Map<int, double> income;
    Map<int, double> expenses;
    MockIncomeExpenseReady state;

    setUp(() {
      income = {
        DateTime.july: 74463.70,
        DateTime.june: 59342.80,
        DateTime.may: 61174.50,
        DateTime.april: 113168.45,
        DateTime.march: 72761.86,
        DateTime.february: 78200.95,
      };

      expenses = {
        DateTime.july: 43415.92,
        DateTime.june: 38707.92,
        DateTime.may: 39559.09,
        DateTime.april: 29334.30,
        DateTime.march: 39679.46,
        DateTime.february: 36718.93,
      };

      state = MockIncomeExpenseReady();
      when(state.netAmount).thenReturn(31047.48);
      when(state.income).thenReturn(income);
      when(state.expenses).thenReturn(expenses);
      when(state.chartMetadata).thenReturn(MockChartMetadata());

      when(_bloc.state).thenReturn(state);
    });

    testWidgets('should show net amount', (tester) async {
      await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

      expect(
          tester.widget(find.byKey(ValueKey('income-expense-net-amount'))),
          isA<Text>().having((Text t) => t.data,
              'shows the net amount for current month', '31,047.48'));
    });

    group("net amount", () {
      testWidgets("should be green if income > expense", (tester) async {
        when(state.netAmount).thenReturn(31047.48);

        await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

        expect(
            tester.widget(find.byKey(ValueKey('income-expense-net-amount'))),
            isA<Text>().having((Text t) => t.style.color,
                'text color equals green', Colors.greenAccent));
      });
      testWidgets("should be grey if expense == income", (tester) async {
        when(state.netAmount).thenReturn(0);

        await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

        expect(
            tester.widget(find.byKey(ValueKey('income-expense-net-amount'))),
            isA<Text>().having((Text t) => t.style.color,
                'text color equals green', Colors.grey));
      });
      testWidgets("should be red if expense > income", (tester) async {
        when(state.netAmount).thenReturn(-1886.04);

        await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

        expect(
            tester.widget(find.byKey(ValueKey('income-expense-net-amount'))),
            isA<Text>().having((Text t) => t.style.color,
                'text color equals green', Colors.redAccent));
      });
    });

    testWidgets('should show line graph', (tester) async {
      await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

      expect(find.byKey(ValueKey('income-expense-line-graph')), findsOneWidget);
    });

    group('line chart', () {
      testWidgets('income graph', (tester) async {
        await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

        expect(
            tester.widget(find.byType(LineChart)),
            isA<LineChart>().having(
                (LineChart lc) => lc.data.lineBarsData[0].spots.map((e) => e.y),
                'contains the income data',
                income.values));
      });

      testWidgets('expense graph', (tester) async {
        await tester.pumpWidget(_widgetWrapper(IncomeExpenseSummaryCard()));

        expect(
            tester.widget(find.byType(LineChart)),
            isA<LineChart>().having(
                (LineChart lc) => lc.data.lineBarsData[1].spots.map((e) => e.y),
                'contains the expense data',
                expenses.values));
      });
    });
  });
}
