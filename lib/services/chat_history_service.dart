import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_session.dart';

class ChatHistoryService {
  static const _key = 'chat_session_ids';
  static const _sessionPrefix = 'session_';

  Future<List<ChatSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    final sessions = <ChatSession>[];
    for (final id in ids) {
      final raw = prefs.getString('$_sessionPrefix$id');
      if (raw != null) {
        try {
          sessions.add(ChatSession.decode(raw));
        } catch (_) {}
      }
    }
    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions;
  }

  Future<void> saveSession(ChatSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(session.id)) {
      ids.add(session.id);
      await prefs.setStringList(_key, ids);
    }
    await prefs.setString('$_sessionPrefix${session.id}', session.encode());
  }

  Future<void> deleteSession(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    ids.remove(id);
    await prefs.setStringList(_key, ids);
    await prefs.remove('$_sessionPrefix$id');
  }
}
