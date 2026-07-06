import '../models/feed_item.dart';
import 'feed_repository.dart';

class ApiFeedRepository implements FeedRepository {
  ApiFeedRepository();

  // TODO: wire to the generated API client once the feed endpoint is
  // supported. Stubbed to return an empty feed so the build passes.
  @override
  Future<List<FeedItem>> getFeed() async {
    return const <FeedItem>[];
  }
}

class FeedItemMapper {
  static FeedItem fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      insight: json['insight'] as String? ?? '',
      timeAgo: json['time_ago'] as String? ?? '',
      impact: json['impact'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
    );
  }
}
