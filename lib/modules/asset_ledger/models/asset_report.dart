import 'package:flutter/foundation.dart';

class AssetReport {
  final List<AssetReportGroup> groups;

  AssetReport({
    @required this.groups,
  });

  double get balance =>
      this.groups.fold(0, (sum, entry) => sum + (entry.balance ?? 0));

  double get changePercent =>
      this.groups.fold(
          0,
          (result, group) =>
              result + ((group.changePercent ?? 0) * group.balance)) /
      this.balance;
}

class AssetReportGroup {
  final String id;
  final String name;
  final List<AssetReportGroupEntry> entries = [];

  AssetReportGroup({
    @required this.id,
    @required this.name,
  });

  double get balance =>
      this.entries.fold(0, (sum, entry) => sum + entry.amount);

  double get changePercent => this.balance == 0
      ? 0.0
      : this.entries.fold(
              0,
              (result, entry) =>
                  result + ((entry.changePercent ?? 0) * entry.amount)) /
          this.balance;
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
