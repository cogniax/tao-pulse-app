import '../../../api/api_client.dart';
import '../models/feed_item.dart';
import 'feed_repository.dart';

class ApiFeedRepository implements FeedRepository {
  ApiFeedRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<FeedItem>> getFeed() async {
    final data = await _apiClient.get('/api/v1/feed');
    final items = (data['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(FeedItemMapper.fromJson)
        .toList();
    return items;
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
      tags: (json['tags'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(),
    );
  }
}
