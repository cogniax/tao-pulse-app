import '../models/feed_item.dart';

final _subnetTagPattern = RegExp(r'^SN(\d+)$');

int? netuidFromWatchlistItem(dynamic item) {
  if (item is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(item);
  final netuid = map['netuid'];
  if (netuid is int) {
    return netuid;
  }
  if (netuid != null) {
    return int.tryParse(netuid.toString());
  }
  final entityType = (map['entity_type'] ?? map['type'])?.toString().toLowerCase();
  if (entityType == 'subnet') {
    final id = map['entity_id'] ?? map['id'];
    if (id is int) {
      return id;
    }
    if (id != null) {
      return int.tryParse(id.toString());
    }
  }
  return null;
}

Set<int> watchedNetuidsFromItems(List<dynamic> items) {
  return items.map(netuidFromWatchlistItem).whereType<int>().toSet();
}

int? netuidFromFeedTag(String tag) {
  final match = _subnetTagPattern.firstMatch(tag);
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(1)!);
}

List<FeedItem> filterFeedByWatchlist(List<FeedItem> items, Set<int> watchedNetuids) {
  if (watchedNetuids.isEmpty) {
    return const [];
  }
  return items
      .where(
        (item) => item.tags
            .map(netuidFromFeedTag)
            .whereType<int>()
            .any(watchedNetuids.contains),
      )
      .toList();
}

List<FeedItem> applyFeedFilter(
  List<FeedItem> items,
  String filter, {
  Set<int> watchedNetuids = const {},
}) {
  switch (filter) {
    case 'All':
      return items;
    case 'Watchlist':
      return filterFeedByWatchlist(items, watchedNetuids);
    case 'Subnets':
      return items
          .where((item) => item.category == 'Subnet Activity')
          .toList();
    case 'Stake':
      return items
          .where((item) => item.category == 'Stake Movement')
          .toList();
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
