import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/features/feed/models/feed_item.dart';
import 'package:taopulse/features/feed/presentation/feed_validators.dart';

void main() {
  test('validator filter includes validator-tagged stake items', () {
    const item = FeedItem(
      id: '2',
      category: 'Stake Movement',
      title: 'Whale staked 28,000 TAO into SN8',
      summary: 'Delegated to Validator 12 in Subnet 8.',
      insight: '',
      timeAgo: '7m ago',
      impact: 'High',
      tags: ['SN8', 'Validator #12', 'Whale'],
    );

    expect(feedItemMatchesValidatorFilter(item), isTrue);
  });
}
