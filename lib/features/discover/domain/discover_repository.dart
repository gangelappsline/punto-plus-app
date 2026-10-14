import 'business.dart';

abstract interface class DiscoverRepository {
  Future<List<Business>> businesses();
}
