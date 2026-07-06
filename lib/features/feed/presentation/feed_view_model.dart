import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_feed_repository.dart';
import '../data/feed_repository.dart';
import '../models/feed_item.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return ApiFeedRepository();
});

final feedViewModelProvider = FutureProvider<List<FeedItem>>((ref) async {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.getFeed();
});
