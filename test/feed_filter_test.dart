import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/features/feed/models/feed_item.dart';
import 'package:taopulse/features/feed/presentation/feed_filter.dart';

void main() {
  test('Watchlist filter keeps only items for watched netuids', () {
    const items = [
      FeedItem(
        id: '1',
        category: 'Subnet Activity',
        title: 'SN15 up',
        summary: '',
        insight: '',
        timeAgo: '1m',
        impact: 'High',
        tags: ['SN15'],
      ),
      FeedItem(
        id: '2',
        category: 'Stake Movement',
        title: 'SN8 stake',
        summary: '',
        insight: '',
        timeAgo: '2m',
        impact: 'High',
        tags: ['SN8'],
      ),
    ];

    final filtered = filterFeedByWatchlist(items, {8});

    expect(filtered, hasLength(1));
    expect(filtered.first.id, '2');
  });

  test('watchedNetuidsFromItems parses subnet entries', () {
    final netuids = watchedNetuidsFromItems([
      {'type': 'subnet', 'netuid': 8},
      {'entity_type': 'validator', 'id': 'abc'},
      {'entity_type': 'subnet', 'entity_id': 19},
    ]);

    expect(netuids, {8, 19});
  });
}
