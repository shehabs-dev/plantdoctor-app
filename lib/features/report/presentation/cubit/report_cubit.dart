import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/error_message_key.dart';
import '../../../../../core/helpers/failure_x.dart';
import '../../../../../core/helpers/uuid_generator.dart';
import '../../../network_system/domain/repositories/network_info.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/get_pending_reports_usecase.dart';
import '../../domain/usecases/submit_report_usecase.dart';
import '../../domain/usecases/sync_reports_usecase.dart';
import '../../domain/usecases/upload_report_image_usecase.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUsecase _submitReportUsecase;
  final UploadReportImageUsecase _uploadReportImageUsecase;
  final GetPendingReportsUsecase _getPendingReportsUsecase;
  final SyncReportsUsecase _syncReportsUsecase;
  final NetworkInfo _networkInfo;

  ReportCubit({
    required SubmitReportUsecase submitReportUsecase,
    required UploadReportImageUsecase uploadReportImageUsecase,
    required GetPendingReportsUsecase getPendingReportsUsecase,
    required SyncReportsUsecase syncReportsUsecase,
    required NetworkInfo networkInfo,
  }) : _submitReportUsecase = submitReportUsecase,
       _uploadReportImageUsecase = uploadReportImageUsecase,
       _getPendingReportsUsecase = getPendingReportsUsecase,
       _syncReportsUsecase = syncReportsUsecase,
       _networkInfo = networkInfo,
       super(ReportInitial());

  // ── Load pending with loading state — for initial banner load ─────────────
  Future<void> loadPendingReports(String userId) async {
    emit(ReportLoading(ReportAction.loadingPending));
    final result = await _getPendingReportsUsecase(userId);
    result.fold(
      (failure) => emit(ReportError(failure.toKey())),
      (reports) => emit(PendingReportsLoaded(reports)),
    );
  }

  // ── Silent refresh — no loading state — used after submit/sync ────────────
  Future<void> _refreshPendingReports(String userId) async {
    final result = await _getPendingReportsUsecase(userId);
    result.fold(
      (_) => null, // silent fail
      (reports) => emit(PendingReportsLoaded(reports)),
    );
  }

  // ── Sync pending reports ───────────────────────────────────────────────────
  // Called by ReportPendingBanner — auto on connectivity restore or manual tap.
  Future<void> syncPendingReports(String userId) async {
    // Check reachability first — do NOT emit loading before this,
    // so the banner never flickers/disappears during the check.
    final isOnline = await _networkInfo.isConnected;

    if (!isOnline) {
      // Stay on current PendingReportsLoaded state, just signal offline.
      emit(ReportSyncFailed());
      // Restore pending list so the banner re-renders correctly.
      await _refreshPendingReports(userId);
      return;
    }

    // Online — show spinner by emitting syncing flag alongside current reports.
    // We use a dedicated state so the banner stays visible during sync.
    emit(ReportSyncing());

    final result = await _syncReportsUsecase();
    result.fold(
      (_) async {
        // Sync call itself failed — refresh and signal failure.
        emit(ReportSyncFailed());
        await _refreshPendingReports(userId);
      },
      (syncedCount) async {
        // Refresh list — if empty the banner will hide itself.
        await _refreshPendingReports(userId);
      },
    );
  }

  // ── Submit report ──────────────────────────────────────────────────────────
  Future<void> submitReport({
    required String userId,
    required String name,
    required String email,
    required String description,
    required String phoneNumber,
    String? address,
    File? image,
  }) async {
    emit(ReportLoading(ReportAction.submitting));
    final canProceed = await _networkInfo.isConnected;

    String? imageURL;

    // ── Upload image only when online ────────────────────────────────────
    if (image != null && canProceed) {
      final uploadResult = await _uploadReportImageUsecase(image);
      final uploadFailed = uploadResult.fold(
        (failure) {
          emit(ReportError(failure.toKey()));
          return true;
        },
        (url) {
          imageURL = url;
          return false;
        },
      );
      if (uploadFailed) return;
    }

    final report = ReportEntity(
      id: UuidGenerator.generate(),
      userId: userId,
      name: name,
      email: email,
      description: description,
      phoneNumber: phoneNumber,
      address: address?.trim().isEmpty == true ? null : address?.trim(),
      imageURL: imageURL,
      imagePath: image?.path,
      reportDate: DateTime.now(),
      isSynced: false,
    );

    final result = await _submitReportUsecase(report, isOnline: canProceed);
    result.fold((failure) => emit(ReportError(failure.toKey())), (_) {
      emit(ReportSubmitted(isSynced: canProceed));
      _refreshPendingReports(userId);
    });
  }
}
