import 'package:flutter/foundation.dart';

class AssetReport {
  final List<AssetReportGroup> groups;

  AssetReport({
    @required this.groups,
  });

  double get balance => 523720.72;

  double get changePercent => 0.0;
}

class AssetReportGroup {
  final String id;
  final String name;
  final List<AssetReportGroupEntry> entries = [];

  AssetReportGroup({
    @required this.id,
    @required this.name,
  });
}

class AssetReportGroupEntry {
  final String name;
  final double amount;
  final double changePercent;
  final String description;

  AssetReportGroupEntry({
    @required this.name,
    @required this.amount,
    @required this.changePercent,
    this.description,
  });
}
