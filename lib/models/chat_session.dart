import 'dart:convert';
import 'chat_message.dart';

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        messages: (json['messages'] as List)
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList(),
      );

  static ChatSession create(List<ChatMessage> messages) {
    final firstUserMsg = messages.firstWhere(
      (m) => m.role == MessageRole.user,
      orElse: () => messages.first,
    );
    final title = firstUserMsg.text.length > 50
        ? '${firstUserMsg.text.substring(0, 50)}...'
        : firstUserMsg.text;
    return ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      messages: List.unmodifiable(messages),
    );
  }

  String encode() => jsonEncode(toJson());

  static ChatSession decode(String raw) =>
      ChatSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
