import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    super.isSynced = true,
  });

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced, // ← Preserve sync status in cache
    };
  }

  factory ChatModel.fromHiveMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isSynced: (map['isSynced'] as bool?) ?? false, // ← Preserve actual value
    );
  }

  /// Direct Firestore write from the app (offline sync path only).
  /// RAG creates/updates chat docs when [createChat] + message API succeed online.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'userId': userId,
      'title': title,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ChatModel.fromFirestoreMap(Map<String, dynamic> map) {
    return ChatModel(
      id: (map['chat_id'] ?? map['id']) as String,
      userId: (map['user_id'] ?? map['userId']) as String,
      title: (map['title'] ?? '') as String,
      createdAt: (map['created_at'] ?? map['createdAt']) is Timestamp
          ? ((map['created_at'] ?? map['createdAt']) as Timestamp).toDate()
          : DateTime.tryParse((map['created_at'] ?? map['createdAt']) as String? ?? '') ??
              DateTime.now(),
      updatedAt: (map['updated_at'] ?? map['updatedAt']) is Timestamp
          ? ((map['updated_at'] ?? map['updatedAt']) as Timestamp).toDate()
          : DateTime.tryParse((map['updated_at'] ?? map['updatedAt']) as String? ?? '') ??
              DateTime.now(),
      isSynced: true,
    );
  }
}
