class ReportEntity {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String description;
  final String phoneNumber;
  final String? address;
  final String? imageURL;
  final String? imagePath;
  final DateTime reportDate;
  final bool isSynced;

  const ReportEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.description,
    required this.phoneNumber,
    this.address,
    this.imageURL,
    this.imagePath,
    required this.reportDate,
    required this.isSynced,
  });
}
