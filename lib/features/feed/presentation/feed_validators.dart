import '../models/feed_item.dart';

bool feedItemMatchesValidatorFilter(FeedItem item) {
  final haystack = [
    item.category,
    item.title,
    item.summary,
    item.insight,
    ...item.tags,
  ];
  return haystack.any((value) => value.toLowerCase().contains('validator'));
}
