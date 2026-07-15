part of 'report_cubit.dart';

enum ReportAction { none, submitting, loadingPending }

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {
  final ReportAction action;
  const ReportLoading(this.action);

  @override
  List<Object?> get props => [action];
}

class ReportSubmitted extends ReportState {
  final bool isSynced;
  const ReportSubmitted({required this.isSynced});

  @override
  List<Object?> get props => [isSynced];
}

class PendingReportsLoaded extends ReportState {
  final List<ReportEntity> reports;
  const PendingReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

// Emitted while syncPendingReports() is in progress.
// Banner stays visible and shows a spinner.
class ReportSyncing extends ReportState {}

// Emitted when sync is attempted but device is offline or sync call failed.
// Banner uses a BlocListener to show a snackbar then immediately gets
// replaced by a fresh PendingReportsLoaded from _refreshPendingReports.
class ReportSyncFailed extends ReportState {
  final String _id;
  ReportSyncFailed() : _id = UuidGenerator.generate();

  @override
  List<Object?> get props => [_id];
}

class ReportError extends ReportState {
  final ErrorMessageKey key;
  final String _id;

  ReportError(this.key) : _id = UuidGenerator.generate();

  @override
  List<Object?> get props => [key, _id];
}

extension ReportStateX on ReportState {
  bool isLoading(ReportAction action) =>
      this is ReportLoading && (this as ReportLoading).action == action;
}
