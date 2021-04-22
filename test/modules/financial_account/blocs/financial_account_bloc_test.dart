import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/financial_account/blocs/financial_account_bloc.dart';
import 'package:kwartz_mobile/modules/transaction/models/transaction.dart';
import 'package:kwartz_mobile/modules/financial_account/repositories/financial_account_repository.dart';
import 'package:mockito/mockito.dart';

class MockFinancialAccountRepository extends Mock
    implements FinancialAccountRepository {}

void main() {
  FinancialAccountRepository financialAccountRepository;

  setUp(() {
    financialAccountRepository = MockFinancialAccountRepository();
  });

  group('FinancialAccountBloc', () {
    final accounts = [
      FinancialAccount(1, 'Cash'),
      FinancialAccount(2, 'Expense'),
      FinancialAccount(3, 'Capital'),
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
        ],
        verify: (_) => verify(financialAccountRepository.getAll()).called(1));
  });
}
