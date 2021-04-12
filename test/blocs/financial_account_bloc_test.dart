import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/models/transaction.dart';
import 'package:kwartz_mobile/repositories/financial_account_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kwartz_mobile/blocs/financial_account_bloc.dart';

class MockFinancialAccountRepository extends Mock
    implements FinancialAccountRepository {}

@GenerateMocks([FinancialAccount])
void main() {
  FinancialAccountRepository financialAccountRepository;

  setUp(() {
    financialAccountRepository = MockFinancialAccountRepository();
  });

  group('FinancialAccountBloc', () {
    final accounts = [
      FinancialAccount('Cash'),
      FinancialAccount('Expense'),
      FinancialAccount('Capital'),
    ];

    test('should initialize to PrebootState', () {
      expect(FinancialAccountBloc(financialAccountRepository).state,
          isA<PrebootState>());
    });

    blocTest<FinancialAccountBloc, FinancialAccountState>(
        'emits [ReadyState] when BootEvent is added',
        build: () {
          when(financialAccountRepository.getAll())
              .thenAnswer((_) async => accounts);

          return FinancialAccountBloc(financialAccountRepository);
        },
        act: (bloc) async => bloc.add(BootEvent()),
        expect: [
          ReadyState(accounts),
        ]);
  });
}
