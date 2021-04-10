import '../models/transaction.dart';
import 'api.dart';

class FinancialAccountRepository {
  final apiClient = ApiClient();

  static final URL = "/api/v1/accounts";

  Future<List<FinancialAccount>> fetchAll() async {
    var response = await apiClient.get(path: URL);
    return _decode(response as List<Map<String, Object>>);
  }

  List<FinancialAccount> _decode(List<Map<String, Object>> accounts) {
    return accounts.map((e) => _decodeObject(e)).toList();
  }

  FinancialAccount _decodeObject(Map<String, Object> properties) {
    return FinancialAccount(properties['name']);
  }
}
