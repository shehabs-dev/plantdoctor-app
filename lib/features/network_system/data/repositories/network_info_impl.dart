import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';
import '../../domain/repositories/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  static const Duration _cacheTtl = Duration(seconds: 4);
  static const Duration _probeTimeout = Duration(seconds: 5);

  final Connectivity _connectivity;
  final Dio _dio;
  final FirebaseFirestore _firestore;
  DateTime? _lastCheckedAt;
  bool? _lastKnownStatus;
  Set<ConnectivityResult>? _lastConnectivityResults;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  NetworkInfoImpl({
    required Connectivity connectivity,
    required Dio dio,
    required FirebaseFirestore firestore,
  }) : _connectivity = connectivity,
       _dio = dio,
       _firestore = firestore {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      _lastConnectivityResults = results.toSet();
      _invalidateCache();
    });
  }

  Future<void> dispose() async {
    await _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  @override
  Future<bool> get isConnected async {
    final connectivityResults = await _connectivity.checkConnectivity();
    final current = connectivityResults.toSet();
    final hasNetworkInterface = current.any(
      (r) => r != ConnectivityResult.none,
    );

    final previous = _lastConnectivityResults;
    final connectivityChanged =
        previous != null && !_sameConnectivitySet(previous, current);
    _lastConnectivityResults = current;

    if (connectivityChanged) {
      _invalidateCache();
    } else {
      final now = DateTime.now();
      if (_lastCheckedAt != null &&
          _lastKnownStatus != null &&
          now.difference(_lastCheckedAt!) < _cacheTtl) {
        return _lastKnownStatus!;
      }
    }

    if (!hasNetworkInterface) {
      _cacheStatus(false);
      return _lastKnownStatus!;
    }

    final reachable = await _probeBackendReachability();
    _cacheStatus(reachable);
    return reachable;
  }

  void _cacheStatus(bool value) {
    _lastKnownStatus = value;
    _lastCheckedAt = DateTime.now();
  }

  void _invalidateCache() {
    _lastKnownStatus = null;
    _lastCheckedAt = null;
  }

  bool _sameConnectivitySet(
    Set<ConnectivityResult> a,
    Set<ConnectivityResult> b,
  ) {
    if (a.length != b.length) return false;
    for (final v in a) {
      if (!b.contains(v)) return false;
    }
    return true;
  }

  Future<bool> _probeBackendReachability() async {
    // 1) FastAPI (Dio)
    try {
      final response = await _dio
          .get<dynamic>(
            '${EnvConfig.ragBaseUrl}/health',
            options: Options(
              sendTimeout: _probeTimeout,
              receiveTimeout: _probeTimeout,
              validateStatus: (status) => status != null && status < 500,
            ),
          )
          .timeout(_probeTimeout);

      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        return true;
      }
    } catch (_) {}

    // 2) Firestore (server-only read)
    try {
      await _firestore
          .doc('_network/ping')
          .get(const GetOptions(source: Source.server))
          .timeout(_probeTimeout);
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') return true;
      return false;
    } catch (_) {
      return false;
    }
  }
}
