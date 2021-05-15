import 'package:flutter/foundation.dart';

class AssetReport {
  final List<AssetReportGroup> groups;

  AssetReport({
    @required this.groups,
  });
}

class AssetReportGroup {
  final String name;
  final List<AssetReportGroupEntry> entries;

  AssetReportGroup({
    @required this.name,
    @required this.entries,
  });
}

class AssetReportGroupEntry {
  final String name;
  final String description;
  final String amount;

  AssetReportGroupEntry({
    @required this.name,
    @required this.description,
    @required this.amount,
  });
}
