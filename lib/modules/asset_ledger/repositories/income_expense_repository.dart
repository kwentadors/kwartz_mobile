import 'package:kwartz_mobile/modules/asset_ledger/models/income_expense_report.dart';
import 'package:kwartz_mobile/utils/repositories/api.dart';

class IncomeExpenseRepository {
  final apiClient = ApiClient();

  Future<IncomeExpenseReport> fetch() async {
    await Future.delayed(Duration(seconds: 2));

    return IncomeExpenseReport();
  }
}
