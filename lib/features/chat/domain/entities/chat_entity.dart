class ChatEntity {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const ChatEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

  ChatEntity copyWith({bool? isSynced}) {
    return ChatEntity(
      id: id,
      userId: userId,
      title: title,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
