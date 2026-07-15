class AutoReportEntity {
  final String id;
  final String userId;
  final String label;
  final double confidence;
  final String imageURL;
  final String? imagePath;
  final double latitude;
  final double longitude;
  final String? governorate;
  final DateTime timestamp;
  final bool isSynced;

  const AutoReportEntity({
    required this.id,
    required this.userId,
    required this.label,
    required this.confidence,
    required this.imageURL,
    this.imagePath,
    required this.latitude,
    required this.longitude,
    this.governorate,
    required this.timestamp,
    required this.isSynced,
  });
}
