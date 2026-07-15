import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.email,
    required super.description,
    required super.phoneNumber,
    super.address,
    super.imageURL,
    super.imagePath,
    required super.reportDate,
    required super.isSynced,
  });

  factory ReportModel.fromEntity(ReportEntity entity) => ReportModel(
    id: entity.id,
    userId: entity.userId,
    name: entity.name,
    email: entity.email,
    description: entity.description,
    phoneNumber: entity.phoneNumber,
    address: entity.address,
    imageURL: entity.imageURL,
    imagePath: entity.imagePath,
    reportDate: entity.reportDate,
    isSynced: entity.isSynced,
  );

  // ── Local Hive storage ─────────────────────────────────────────────────────
  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'email': email,
    'description': description,
    'phoneNumber': phoneNumber,
    'address': address,
    'imageURL': imageURL,
    'imagePath': imagePath,
    'reportDate': reportDate.toIso8601String(),
    'isSynced': isSynced,
  };

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    name: map['name'] as String,
    email: map['email'] as String,
    description: map['description'] as String,
    phoneNumber: map['phoneNumber'] as String,
    address: map['address'] as String?,
    imageURL: map['imageURL'] as String?,
    imagePath: map['imagePath'] as String?,
    reportDate: DateTime.parse(map['reportDate'] as String),
    isSynced: map['isSynced'] as bool,
  );

  // ── Firestore — imagePath excluded ────────────────────────────────────────
  Map<String, dynamic> toFirestoreMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'email': email,
    'description': description,
    'phoneNumber': phoneNumber,
    'address': address,
    'imageURL': imageURL,
    'reportDate': Timestamp.fromDate(reportDate),
    'isSynced': true,
  };

  factory ReportModel.fromFirestoreMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    name: map['name'] as String,
    email: map['email'] as String,
    description: map['description'] as String,
    phoneNumber: map['phoneNumber'] as String,
    address: map['address'] as String?,
    imageURL: map['imageURL'] as String?,
    imagePath: null,
    reportDate: (map['reportDate'] as Timestamp).toDate(),
    isSynced: true,
  );

  ReportModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? description,
    String? phoneNumber,
    String? address,
    String? imageURL,
    String? imagePath,
    DateTime? reportDate,
    bool? isSynced,
  }) => ReportModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    description: description ?? this.description,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    address: address ?? this.address,
    imageURL: imageURL ?? this.imageURL,
    imagePath: imagePath ?? this.imagePath,
    reportDate: reportDate ?? this.reportDate,
    isSynced: isSynced ?? this.isSynced,
  );
}
