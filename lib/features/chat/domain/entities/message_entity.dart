class MessageEntity {
  final String id;
  final String chatId;
  final String? prompt;
  final String? imageURL;
  final String? localImagePath;
  final String? label;
  final double? confidence;
  final String? ragResponse;
  final MessageRole role;
  final DateTime timestamp;
  final bool isSynced;

  const MessageEntity({
    required this.id,
    required this.chatId,
    this.prompt,
    this.imageURL,
    this.localImagePath,
    this.label,
    this.confidence,
    this.ragResponse,
    required this.role,
    required this.timestamp,
    this.isSynced = true,
  });

  MessageEntity copyWith({
    String? prompt,
    String? imageURL,
    String? localImagePath,
    String? label,
    double? confidence,
    String? ragResponse,
    bool? isSynced,
  }) {
    return MessageEntity(
      id: id,
      chatId: chatId,
      prompt: prompt ?? this.prompt,
      imageURL: imageURL ?? this.imageURL,
      localImagePath: localImagePath ?? this.localImagePath,
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      ragResponse: ragResponse ?? this.ragResponse,
      role: role,
      timestamp: timestamp,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

enum MessageRole { user, assistant }
