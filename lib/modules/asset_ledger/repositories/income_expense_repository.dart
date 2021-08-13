import 'package:flutter/material.dart';
import '../models/income_expense_report.dart';
import '../serializers/income_expense_report_serializer.dart';
import '../../../utils/repositories/api.dart';

class IncomeExpenseRepository {
  final apiClient = ApiClient();
  final IncomeExpenseReportSerializer serializer;
  static const URL = "/api/v1/reports/income-expense";

  IncomeExpenseRepository({@required this.serializer});

  Future<IncomeExpenseReport> fetch() async {
    var response = await apiClient.get(path: URL);
    var report = serializer.deserialize(response);
    return report;
  }
}
