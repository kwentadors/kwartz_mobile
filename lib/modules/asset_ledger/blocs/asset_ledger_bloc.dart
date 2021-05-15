import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/asset_report.dart';

part 'asset_ledger_event.dart';
part 'asset_ledger_state.dart';

class AssetLedgerBloc extends Bloc<AssetLedgerEvent, AssetLedgerState> {
  AssetLedgerBloc() : super(AssetLedgerReady());

  @override
  Stream<AssetLedgerState> mapEventToState(
    AssetLedgerEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
