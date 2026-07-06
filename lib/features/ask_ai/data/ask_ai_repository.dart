import 'package:flutter_riverpod/flutter_riverpod.dart';

final askAiRepositoryProvider = Provider<AskAiRepository>((ref) {
  return AskAiRepository();
});

final askAiDashboardProvider = FutureProvider<AskAiDashboard>((ref) async {
  return ref.watch(askAiRepositoryProvider).getDashboard();
});

class AskAiRepository {
  AskAiRepository();

  // TODO: wire to the generated API client once the chat endpoints are
  // supported. Stubbed to return empty/default data so the build passes.
  Future<AskAiDashboard> getDashboard() async {
    return const AskAiDashboard(
      suggestions: <AskAiPrompt>[],
      history: <ChatHistoryItem>[],
    );
  }

  Future<ChatReply> sendMessage(String message, {String? threadId}) async {
    return ChatReply(
      threadId: threadId ?? '',
      content: '',
      sources: const <String>[],
    );
  }
}

class AskAiDashboard {
  const AskAiDashboard({required this.suggestions, required this.history});

  final List<AskAiPrompt> suggestions;
  final List<ChatHistoryItem> history;
}

class AskAiPrompt {
  const AskAiPrompt({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.topic,
  });

  final String id;
  final String title;
  final String subtitle;
  final String topic;

  factory AskAiPrompt.fromJson(Map<String, dynamic> json) {
    return AskAiPrompt(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
    );
  }
}

class ChatHistoryItem {
  const ChatHistoryItem({
    required this.id,
    required this.title,
    required this.timeAgo,
  });

  final String id;
  final String title;
  final String timeAgo;

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) {
    return ChatHistoryItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      timeAgo: json['time_ago'] as String? ?? '',
    );
  }
}

class ChatReply {
  const ChatReply({
    required this.threadId,
    required this.content,
    required this.sources,
  });

  final String threadId;
  final String content;
  final List<String> sources;

  factory ChatReply.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>? ?? const {};
    return ChatReply(
      threadId: json['thread_id'] as String? ?? '',
      content: message['content'] as String? ?? '',
      sources: (message['sources'] as List<dynamic>? ?? <dynamic>[])
          .cast<String>(),
    );
  }
}
