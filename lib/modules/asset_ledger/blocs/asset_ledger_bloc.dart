import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/asset_report_repository.dart';
import '../models/asset_report.dart';

part 'asset_ledger_event.dart';
part 'asset_ledger_state.dart';

class AssetLedgerBloc extends Bloc<AssetLedgerEvent, AssetLedgerState> {
  final AssetReportRepository repository;

  AssetLedgerBloc(this.repository) : super(AssetLedgerInitial()) {
    add(FetchAssetReport());
  }

  @override
  Stream<AssetLedgerState> mapEventToState(
    AssetLedgerEvent event,
  ) async* {
    if (event is FetchAssetReport) {
      yield AssetLedgerLoading();
      var assetReport = await repository.fetch();
      yield AssetLedgerReady(assetReport);
    }
  }
}
