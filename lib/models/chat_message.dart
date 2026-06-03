enum MessageRole { user, assistant }

class ChatMessage {
  final String text;
  final MessageRole role;

  const ChatMessage({required this.text, required this.role});

  Map<String, dynamic> toJson() => {'text': text, 'role': role.name};

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'] as String,
        role: MessageRole.values.firstWhere((r) => r.name == json['role']),
      );
}
