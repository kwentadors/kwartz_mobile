import 'package:flutter/foundation.dart';

class AssetReport {
  final List<AssetReportGroup> groups;

  AssetReport({
    @required this.groups,
  });

  double get balance => 523720.72;

  double get changePercent => -2.45;
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
  final double amount;
  final String description;

  AssetReportGroupEntry({
    @required this.name,
    @required this.amount,
    this.description,
  });
}
