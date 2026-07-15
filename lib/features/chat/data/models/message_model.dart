import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

DateTime _timestampFromMap(Map<String, dynamic> map) {
  final raw = map['created_at'] ?? map['updated_at'] ?? map['timestamp'];
  if (raw is Timestamp) return raw.toDate();
  return DateTime.tryParse(raw as String? ?? '') ?? DateTime.now();
}

// ─── Field ownership ────────────────────────────────────────────────────────
// Remote-owned  (Firestore / RAG backend is authoritative):
//   label, confidence, ragResponse
// Local-owned   (device only, never stored in Firestore):
//   localImagePath, isSynced, offline queue state
// Shared        (remote timestamp takes priority when available):
//   id, chatId, prompt, imageURL, timestamp
// ─────────────────────────────────────────────────────────────────────────────

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    super.prompt,
    super.imageURL,
    super.localImagePath,
    super.label,
    super.confidence,
    super.ragResponse,
    required super.role,
    required super.timestamp,
    super.isSynced = true,
  });

  factory MessageModel.fromFirestoreMap(Map<String, dynamic> map) {
    final role = (map['role'] == 'user' || map['role'] == 'USER')
        ? MessageRole.user
        : MessageRole.assistant;

    // Classification fields are owned by Firestore (RAG backend).
    // Map them as-is, regardless of role — never conditionally erase them.
    // Hive is a cache layer only and must not override these on merge.
    return MessageModel(
      id: (map['message_id'] ?? map['id']) as String,
      chatId: (map['chat_id'] ?? map['chatId']) as String,
      prompt: (map['prompt'] ?? map['text']) as String?,
      imageURL: (map['image_url'] ?? map['imageURL']) as String?,
      localImagePath: null, // never stored in Firestore
      label: map['label'] as String?,
      confidence: (map['confidence'] as num?)?.toDouble(),
      ragResponse: (map['rag_response'] ?? map['ragResponse']) as String?,
      role: role,
      timestamp: _timestampFromMap(map),
      isSynced: true,
    );
  }

  /// User messages are display-only input (image/prompt). Classification metadata
  /// must not be rendered from user rows — only assistant [ragResponse].
  MessageModel asInputOnly() {
    if (role != MessageRole.user) return this;
    return MessageModel(
      id: id,
      chatId: chatId,
      prompt: prompt,
      imageURL: imageURL,
      localImagePath: localImagePath,
      label: null,
      confidence: null,
      ragResponse: null,
      role: role,
      timestamp: timestamp,
      isSynced: isSynced,
    );
  }

  factory MessageModel.fromHiveMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      prompt: map['prompt'] as String?,
      imageURL: map['imageURL'] as String?,
      localImagePath: map['localImagePath'] as String?, // ← read from Hive
      label: map['label'] as String?,
      confidence: (map['confidence'] as num?)?.toDouble(),
      ragResponse: map['ragResponse'] as String?,
      role: map['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isSynced: (map['isSynced'] as bool?) ?? false, // ← Preserve actual value
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      prompt: entity.prompt,
      imageURL: entity.imageURL,
      localImagePath: entity.localImagePath, // ← map
      label: entity.label,
      confidence: entity.confidence,
      ragResponse: entity.ragResponse,
      role: entity.role,
      timestamp: entity.timestamp,
      isSynced: entity.isSynced,
    );
  }

  /// Direct Firestore write from the app (offline sync path only).
  /// RAG writes messages (with timestamps) when the message API is called online.
  Map<String, dynamic> toFirestoreMap() {
    final ts = Timestamp.fromDate(timestamp);
    return {
      if (prompt != null) 'prompt': prompt,
      if (imageURL != null) 'image_url': imageURL,
      if (label != null) 'label': label,
      if (confidence != null) 'confidence': confidence,
      if (ragResponse != null) 'rag_response': ragResponse,
      'role': role == MessageRole.user ? 'user' : 'assistant',
      'created_at': ts,
      'updated_at': ts,
    };
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'chatId': chatId,
      'prompt': prompt,
      'imageURL': imageURL,
      'localImagePath': localImagePath, // ← stored in Hive
      'label': label,
      'confidence': confidence,
      'ragResponse': ragResponse,
      'role': role == MessageRole.user ? 'user' : 'assistant',
      'timestamp': timestamp.toIso8601String(),
      'isSynced': isSynced, // ← Preserve sync status in cache
    };
  }
}
