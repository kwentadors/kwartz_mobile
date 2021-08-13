import 'package:kwartz_mobile/modules/asset_ledger/models/income_expense_report.dart';
import 'package:kwartz_mobile/utils/date_utils.dart';

class IncomeExpenseReportSerializer {
  IncomeExpenseReport deserialize(Map json) {
    var report = IncomeExpenseReport();

    (json['income'] as List).forEach((entry) {
      final month = DateUtils.monthIndex(entry["key"]["month"]);
      final year = entry["key"]["year"];
      final income = double.parse(entry["value"].replaceAll(",", ""));

      report.setIncome(month, year, income);
    });

    (json['expense'] as List).forEach((entry) {
      final month = DateUtils.monthIndex(entry["key"]["month"]);
      final year = entry["key"]["year"];
      final expense = double.parse(entry["value"].replaceAll(",", ""));

      report.setExpense(month, year, expense);
    });

    return report;
  }
}
