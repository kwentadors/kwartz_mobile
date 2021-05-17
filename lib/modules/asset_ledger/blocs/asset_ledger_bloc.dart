import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/asset_report.dart';

part 'asset_ledger_event.dart';
part 'asset_ledger_state.dart';

class AssetLedgerBloc extends Bloc<AssetLedgerEvent, AssetLedgerState> {
  AssetLedgerBloc() : super(AssetLedgerInitial()) {
    add(FetchAssetReport());
  }

  @override
  Stream<AssetLedgerState> mapEventToState(
    AssetLedgerEvent event,
  ) async* {
    if (event is FetchAssetReport) {
      yield AssetLedgerLoading();
      await Future.delayed(new Duration(seconds: 5), () => null);
      yield AssetLedgerReady();
    }
  }
}
