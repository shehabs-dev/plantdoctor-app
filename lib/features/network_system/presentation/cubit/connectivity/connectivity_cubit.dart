import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../chat/domain/usecases/sync_pending_messages_usecase.dart';
import '../../../../chat/domain/usecases/sync_pending_reports_usecase.dart';
import '../../../../report/domain/usecases/sync_reports_usecase.dart';
import '../../../data/datasources/connectivity_service.dart';
import '../../../domain/repositories/network_info.dart';
part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _connectivityService;
  final NetworkInfo _networkInfo;
  final SyncPendingReportsUsecase _syncPendingReportsUsecase;
  final SyncPendingMessagesUsecase _syncPendingMessagesUsecase;
  final SyncReportsUsecase _syncReportsUsecase;

  StreamSubscription<bool>? _sub;
  int _reachabilityCheckToken = 0;

  ConnectivityCubit(
    this._connectivityService,
    this._networkInfo,
    this._syncPendingReportsUsecase,
    this._syncPendingMessagesUsecase,
    this._syncReportsUsecase,
  ) : super(ConnectivityOnline()) {
    _syncOnStartupIfOnline();
    _sub = _connectivityService.onConnectivityChanged.listen((
      hasInterface,
    ) async {
      final token = ++_reachabilityCheckToken;
      if (!hasInterface) {
        emit(ConnectivityOffline());
        return;
      }

      final canProceed = await _networkInfo.isConnected;
      if (token != _reachabilityCheckToken) return; // ignore stale result
      if (canProceed) {
        _syncAllPending();
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });
  }

  Future<void> _syncOnStartupIfOnline() async {
    final isOnline = await _networkInfo.isConnected;
    if (isOnline) {
      _syncAllPending();
    } else {
      emit(ConnectivityOffline());
    }
  }

  void _syncAllPending() {
    _syncPendingReportsUsecase();
    _syncPendingMessagesUsecase();
    _syncReportsUsecase();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
