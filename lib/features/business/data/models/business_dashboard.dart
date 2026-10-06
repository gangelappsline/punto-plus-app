import '../../../../core/utils/json.dart';
import '../../../cards/data/models/stamp.dart';

/// Punto de una serie temporal del panel (sellos por día).
final class MetricPoint {
  const MetricPoint({required this.date, required this.value, this.label});

  factory MetricPoint.fromJson(Map<String, dynamic> json) => MetricPoint(
        date: Json.dateOnlyOrNull(
              Json.pick(json, <String>['date', 'day', 'period']),
            ) ??
            DateTime.now(),
        value: Json.integer(
          Json.pick(json, <String>['value', 'count', 'total', 'stamps']),
        ),
        label: Json.textOrNull(json['label']),
      );

  final DateTime date;
  final int value;
  final String? label;
}

/// Cliente destacado del panel.
final class TopCustomer {
  const TopCustomer({
    required this.id,
    required this.name,
    required this.stamps,
    this.avatarUrl,
  });

  factory TopCustomer.fromJson(Map<String, dynamic> json) => TopCustomer(
        id: Json.text(Json.pick(json, <String>['id', 'uuid', 'user_id'])),
        name: Json.text(
          Json.pick(json, <String>['name', 'display_name', 'customer_name']),
          fallback: 'Cliente',
        ),
        stamps: Json.integer(
          Json.pick(json, <String>['stamps', 'stamps_count', 'total_stamps']),
        ),
        avatarUrl: Json.textOrNull(
          Json.pick(json, <String>['avatar_url', 'avatarUrl']),
        ),
      );

  final String id;
  final String name;
  final int stamps;
  final String? avatarUrl;
}

/// Métricas del programa de fidelidad de un negocio.
final class BusinessDashboard {
  const BusinessDashboard({
    this.stampsToday = 0,
    this.stampsMonth = 0,
    this.customersCount = 0,
    this.activeCardsCount = 0,
    this.redemptionsMonth = 0,
    this.series = const <MetricPoint>[],
    this.topCustomers = const <TopCustomer>[],
    this.recentStamps = const <StampModel>[],
  });

  factory BusinessDashboard.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> metrics = Json.mapOrNull(json['metrics']) ?? json;

    return BusinessDashboard(
      stampsToday: Json.integer(
        Json.pick(metrics, <String>['stamps_today', 'stampsToday']),
      ),
      stampsMonth: Json.integer(
        Json.pick(
          metrics,
          <String>['stamps_month', 'stampsMonth', 'stamps_this_month'],
        ),
      ),
      customersCount: Json.integer(
        Json.pick(metrics, <String>['customers_count', 'customersCount']),
      ),
      activeCardsCount: Json.integer(
        Json.pick(metrics, <String>['active_cards', 'activeCardsCount']),
      ),
      redemptionsMonth: Json.integer(
        Json.pick(
          metrics,
          <String>['redemptions_month', 'redemptions', 'redemptionsCount'],
        ),
      ),
      series: Json.maps(
        Json.pick(json, <String>['series', 'chart', 'stamps_by_day']),
      ).map(MetricPoint.fromJson).toList(),
      topCustomers: Json.maps(
        Json.pick(json, <String>['top_customers', 'topCustomers']),
      ).map(TopCustomer.fromJson).toList(),
      recentStamps: Json.maps(
        Json.pick(json, <String>['recent_stamps', 'recentStamps']),
      ).map(StampModel.fromJson).toList(),
    );
  }

  final int stampsToday;
  final int stampsMonth;
  final int customersCount;
  final int activeCardsCount;
  final int redemptionsMonth;
  final List<MetricPoint> series;
  final List<TopCustomer> topCustomers;
  final List<StampModel> recentStamps;

  int get maxSeriesValue {
    int max = 0;
    for (final MetricPoint point in series) {
      if (point.value > max) max = point.value;
    }
    return max;
  }
}
