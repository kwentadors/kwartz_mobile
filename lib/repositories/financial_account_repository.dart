import '../models/transaction.dart';
import 'api.dart';

class FinancialAccountRepository {
  final apiClient = ApiClient();

  static const URL = "/api/v1/accounts";

  List<FinancialAccount> _accountsCache;

  Future<List<FinancialAccount>> getAll() async {
    if (_accountsCache == null) {
      _accountsCache = await _fetchFromDatabase();
    }

    return _accountsCache;
  }

  List<FinancialAccount> _decode(accounts) {
    return new List<FinancialAccount>.from(
        accounts.map((e) => FinancialAccount(e['name'])));
  }

  FinancialAccount _decodeObject(properties) {
    return FinancialAccount(properties['name']);
  }

  Future<List<FinancialAccount>> _fetchFromDatabase() async {
    var response = await apiClient.get(path: URL);
    return _decode(response['data']);
  }
}
