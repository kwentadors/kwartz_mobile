import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/asset_ledger/blocs/income_expense_bloc.dart';
import 'package:kwartz_mobile/modules/asset_ledger/repositories/income_expense_repository.dart';
import 'package:mockito/mockito.dart';

class MockIncomeExpenseRepository extends Mock
    implements IncomeExpenseRepository {}

void main() {
  IncomeExpenseRepository repository;

  group('IncomeExpenseBloc', () {
    setUp(() {
      repository = MockIncomeExpenseRepository();
    });

    test('should initialize to IncomeExpenseInitial state', () {
      expect(IncomeExpenseBloc(repository).state, isA<IncomeExpenseInitial>());
    });

    blocTest(
      'emits [IncomeExpenseReady] when FetchIncomeExpense event',
      build: () =>
          IncomeExpenseBloc(repository)..add(FetchIncomeExpenseReport()),
      expect: [IncomeExpenseReady(null)],
    );
  });
}
