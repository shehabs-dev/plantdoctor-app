import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/auto_report_entity.dart';

class AutoReportModel extends AutoReportEntity {
  const AutoReportModel({
    required super.id,
    required super.userId,
    required super.label,
    required super.confidence,
    required super.imageURL,
    super.imagePath,
    required super.latitude,
    required super.longitude,
    super.governorate,
    required super.timestamp,
    required super.isSynced,
  });

  factory AutoReportModel.fromFirestoreMap(Map<String, dynamic> map) {
    return AutoReportModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      label: map['label'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      imageURL: map['imageURL'] as String,
      imagePath: null,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      governorate: map['governorate'] as String?,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isSynced: map['isSynced'] as bool,
    );
  }

  factory AutoReportModel.fromHiveMap(Map<String, dynamic> map) {
    return AutoReportModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      label: map['label'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      imageURL: map['imageURL'] as String,
      imagePath: map['imagePath'] as String?,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      governorate: map['governorate'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isSynced: (map['isSynced'] as bool?) ?? false,
    );
  }

  factory AutoReportModel.fromEntity(AutoReportEntity entity) {
    return AutoReportModel(
      id: entity.id,
      userId: entity.userId,
      label: entity.label,
      confidence: entity.confidence,
      imageURL: entity.imageURL,
      imagePath: entity.imagePath,
      latitude: entity.latitude,
      longitude: entity.longitude,
      governorate: entity.governorate,
      timestamp: entity.timestamp,
      isSynced: entity.isSynced,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'confidence': confidence,
      'imageURL': imageURL,
      'latitude': latitude,
      'longitude': longitude,
      if (governorate != null) 'governorate': governorate,
      'timestamp': Timestamp.fromDate(timestamp),
      'isSynced': true,
    };
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'confidence': confidence,
      'imageURL': imageURL,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'governorate': governorate,
      'timestamp': timestamp.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  AutoReportModel copyWith({
    String? imageURL,
    String? imagePath,
    String? governorate,
    bool? isSynced,
  }) {
    return AutoReportModel(
      id: id,
      userId: userId,
      label: label,
      confidence: confidence,
      imageURL: imageURL ?? this.imageURL,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude,
      longitude: longitude,
      governorate: governorate ?? this.governorate,
      timestamp: timestamp,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
