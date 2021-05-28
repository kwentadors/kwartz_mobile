import 'package:flutter/foundation.dart';
import '../models/asset_report.dart';
import '../serializers/asset_report_serializer.dart';
import '../../../utils/repositories/api.dart';

class AssetReportRepository {
  final apiClient = ApiClient();
  final AssetReportSerializer serializer;

  static const URL = "/api/v1/reports/assets";

  AssetReportRepository({@required this.serializer});

  Future<AssetReport> fetch() async {
    var response = await apiClient.get(path: URL);
    return serializer.deserialize(response['data']);
  }
}
