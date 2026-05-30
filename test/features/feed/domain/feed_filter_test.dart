import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/features/feed/domain/feed_filter.dart';
import 'package:taopulse/features/feed/models/feed_item.dart';

FeedItem _item({
  String id = '1',
  String category = 'General',
  String title = 'Untitled',
  List<String> tags = const [],
}) {
  return FeedItem(
    id: id,
    category: category,
    title: title,
    summary: '',
    insight: '',
    timeAgo: '',
    impact: '',
    tags: tags,
  );
}

void main() {
  final items = [
    _item(id: 'watch', tags: const ['SN12']),
    _item(id: 'subnet', category: 'Subnet Activity'),
    _item(id: 'stake', category: 'Stake Movement'),
    _item(id: 'validator', title: 'Top Validator joined'),
    _item(id: 'gov', category: 'Governance'),
    _item(id: 'ai', category: 'AI Insight'),
    _item(id: 'other', category: 'General', title: 'Nothing special'),
  ];

  List<String> idsFor(String filter) =>
      applyFeedFilter(items, filter).map((item) => item.id).toList();

  group('applyFeedFilter', () {
    test('All returns every item', () {
      expect(applyFeedFilter(items, 'All'), items);
    });

    test('unknown filter falls back to every item', () {
      expect(applyFeedFilter(items, 'Nope'), items);
    });

    test('Watchlist keeps items tagged with an SN prefix', () {
      expect(idsFor('Watchlist'), ['watch']);
    });

    test('Subnets keeps Subnet Activity category', () {
      expect(idsFor('Subnets'), ['subnet']);
    });

    test('Stake keeps Stake Movement category', () {
      expect(idsFor('Stake'), ['stake']);
    });

    test('Validators matches validator in the title case-insensitively', () {
      expect(idsFor('Validators'), ['validator']);
    });

    test('Governance keeps Governance category', () {
      expect(idsFor('Governance'), ['gov']);
    });

    test('AI Insights keeps AI Insight category', () {
      expect(idsFor('AI Insights'), ['ai']);
    });

    test('does not mutate the input list', () {
      final input = [...items];
      applyFeedFilter(input, 'Subnets');
      expect(input, items);
    });
  });
}
