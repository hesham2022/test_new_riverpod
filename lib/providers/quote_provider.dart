import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_new_riverpod/core/services/quote_service.dart';

final quoteProvider = FutureProvider.autoDispose((_) {
  final quoteService = QuoteService.instance;
  return quoteService.getQuotes();
});
