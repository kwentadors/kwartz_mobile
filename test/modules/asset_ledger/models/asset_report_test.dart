import 'package:flutter_test/flutter_test.dart';
import 'package:kwartz_mobile/modules/asset_ledger/models/asset_report.dart';

void main() {
  group("AssetGroup", () {
    AssetReport assetReport = stubAssetReport();

    test("should return correct total balance", () {
      expect(assetReport.balance, equals(74826.92));
    });

    test("should return correct total change in percent", () {
      expect(assetReport.changePercent, within(distance: 0.01, from: 6.95));
    });
  });
}

AssetReport stubAssetReport() {
  var assetReportGroup1 = AssetReportGroup(
    id: '1',
    name: 'Cash equivalents',
  );
  assetReportGroup1.entries.addAll([
    AssetReportGroupEntry(
      name: 'Savings',
      amount: 72366.92,
      changePercent: 7.2,
    ),
    AssetReportGroupEntry(
      name: 'Checkings',
      amount: 2460.00,
      changePercent: -0.4,
    ),
  ]);

  var assetReportGroup2 = AssetReportGroup(
    id: '2',
    name: 'Paper assets',
  );

  var assetReport = AssetReport(
    groups: <AssetReportGroup>[
      assetReportGroup1,
      assetReportGroup2,
    ],
  );

  return assetReport;
}
