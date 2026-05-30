import '../models/feed_item.dart';

/// Returns the subset of [items] that match the named feed [filter].
///
/// Pure relocation of the former `_applyFilter` heuristic from `FeedScreen`,
/// moved here so the filtering rules can be unit-tested without a widget test.
List<FeedItem> applyFeedFilter(List<FeedItem> items, String filter) {
  switch (filter) {
    case 'All':
      return items;
    case 'Watchlist':
      return items
          .where((item) => item.tags.any((tag) => tag.startsWith('SN')))
          .toList();
    case 'Subnets':
      return items.where((item) => item.category == 'Subnet Activity').toList();
    case 'Stake':
      return items.where((item) => item.category == 'Stake Movement').toList();
    case 'Validators':
      return items
          .where((item) => item.title.toLowerCase().contains('validator'))
          .toList();
    case 'Governance':
      return items.where((item) => item.category == 'Governance').toList();
    case 'AI Insights':
      return items.where((item) => item.category == 'AI Insight').toList();
    default:
      return items;
  }
}
