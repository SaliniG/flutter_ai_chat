enum MessageRole { user, assistant }

class ChatMessage {
  final String text;
  final MessageRole role;

  const ChatMessage({required this.text, required this.role});
}
