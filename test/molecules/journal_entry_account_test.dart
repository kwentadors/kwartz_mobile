import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/financial_account/blocs/financial_account_bloc.dart';
import 'package:kwartz_mobile/modules/transaction/screens/save_transaction_page.dart';
import 'package:mockito/mockito.dart';

class MockFinancialAccountBloc extends MockBloc<FinancialAccountState>
    implements FinancialAccountBloc {}

void main() {
  FinancialAccountBloc bloc;

  setUp(() {
    bloc = MockFinancialAccountBloc();
  });
  group('Journal Entry Account', () {
    testWidgets('renders progress indicator when state is pre-boot',
        (tester) async {
      when(bloc.state).thenReturn(PrebootState());
      await tester.pumpWidget(BlocProvider.value(
        value: bloc,
        child: AccountNameInput(entry: null),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
