import '../models/asset_report.dart';

class AssetReportSerializer {
  AssetReport deserialize(Map json) {
    return AssetReport(
      groups: deserializeGroups(json['groups'], json['accounts']),
    );
  }

  List<AssetReportGroup> deserializeGroups(
      List assetGroupDataList, List assetAccountDataList) {
    final assetGroups = assetGroupDataList
        .map((assetGroupData) => AssetReportGroup(
              id: assetGroupData['id'].toString(),
              name: assetGroupData['name'],
            ))
        .toList();

    assetAccountDataList.forEach((assetEntryData) {
      final assetEntry = AssetReportGroupEntry(
        name: assetEntryData['name'],
        amount: double.parse(assetEntryData['balance']),
        changePercent: (assetEntryData['change'] != null
            ? double.tryParse(assetEntryData['change'])
            : null),
      );

      final assetGroup = assetGroups.firstWhere((assetGroup) =>
          assetGroup.id == assetEntryData['group_id'].toString());
      assetGroup.entries.add(assetEntry);
    });

    return assetGroups;
  }
}
