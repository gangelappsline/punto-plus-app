import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/json.dart';

/// Tarjeta de fidelidad diseñada por un negocio.
final class LoyaltyCardModel {
  const LoyaltyCardModel({
    required this.id,
    required this.name,
    required this.requiredStamps,
    this.businessId,
    this.businessName,
    this.businessLogoUrl,
    this.description,
    this.rewardDescription,
    this.logoUrl,
    this.backgroundUrl,
    this.backgroundColor,
    this.stampIconUrl,
    this.category,
    this.isActive = true,
    this.createdAt,
    this.customersCount = 0,
  });

  factory LoyaltyCardModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> business = Json.mapOrNull(
          Json.pick(json, <String>['business', 'business_info']),
        ) ??
        <String, dynamic>{};

    return LoyaltyCardModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      name: Json.text(
        Json.pick(json, <String>['name', 'title']),
        fallback: 'Tarjeta de fidelidad',
      ),
      requiredStamps: Json.integer(
        Json.pick(
          json,
          <String>[
            'required_stamps',
            'requiredStamps',
            'stamps_required',
            'stamps_to_reward',
          ],
        ),
        fallback: AppConstants.defaultRequiredStamps,
      ),
      businessId: Json.textOrNull(
        Json.pick(json, <String>['business_id', 'businessId']) ??
            business['id'],
      ),
      businessName: Json.textOrNull(
        Json.pick(json, <String>['business_name', 'businessName']) ??
            business['name'],
      ),
      businessLogoUrl: Json.textOrNull(
        Json.pick(json, <String>['business_logo_url', 'businessLogoUrl']) ??
            business['logo_url'] ??
            business['logoUrl'],
      ),
      description: Json.textOrNull(json['description']),
      rewardDescription: Json.textOrNull(
        Json.pick(
          json,
          <String>[
            'reward_description',
            'rewardDescription',
            'reward',
            'prize',
          ],
        ),
      ),
      logoUrl: Json.textOrNull(
        Json.pick(json, <String>['logo_url', 'logoUrl', 'image_url']),
      ),
      backgroundUrl: Json.textOrNull(
        Json.pick(
          json,
          <String>['background_url', 'backgroundUrl', 'cover_url'],
        ),
      ),
      backgroundColor: AppFormatters.colorFromHex(
        Json.textOrNull(
          Json.pick(
            json,
            <String>['background_color', 'backgroundColor', 'color'],
          ),
        ),
      ),
      stampIconUrl: Json.textOrNull(
        Json.pick(json, <String>['stamp_icon_url', 'stampIconUrl', 'icon']),
      ),
      category: Json.textOrNull(json['category']),
      isActive: Json.boolean(
        Json.pick(json, <String>['is_active', 'isActive', 'active']),
        fallback: true,
      ),
      createdAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['created_at', 'createdAt']),
      ),
      customersCount: Json.integer(
        Json.pick(json, <String>['customers_count', 'customersCount']),
      ),
    );
  }

  final String id;
  final String name;
  final int requiredStamps;
  final String? businessId;
  final String? businessName;
  final String? businessLogoUrl;
  final String? description;
  final String? rewardDescription;
  final String? logoUrl;
  final String? backgroundUrl;
  final Color? backgroundColor;
  final String? stampIconUrl;
  final String? category;
  final bool isActive;
  final DateTime? createdAt;
  final int customersCount;

  Color get resolvedBackground =>
      backgroundColor ?? const Color(0xFF007D8D);

  String get displayBusinessName => businessName ?? name;

  LoyaltyCardModel copyWith({
    String? name,
    int? requiredStamps,
    String? description,
    String? rewardDescription,
    String? backgroundUrl,
    Color? backgroundColor,
    String? logoUrl,
    String? stampIconUrl,
    bool? isActive,
  }) =>
      LoyaltyCardModel(
        id: id,
        name: name ?? this.name,
        requiredStamps: requiredStamps ?? this.requiredStamps,
        businessId: businessId,
        businessName: businessName,
        businessLogoUrl: businessLogoUrl,
        description: description ?? this.description,
        rewardDescription: rewardDescription ?? this.rewardDescription,
        logoUrl: logoUrl ?? this.logoUrl,
        backgroundUrl: backgroundUrl ?? this.backgroundUrl,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        stampIconUrl: stampIconUrl ?? this.stampIconUrl,
        category: category,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
        customersCount: customersCount,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'required_stamps': requiredStamps,
        if (businessId != null) 'business_id': businessId,
        if (businessName != null) 'business_name': businessName,
        if (businessLogoUrl != null) 'business_logo_url': businessLogoUrl,
        if (description != null) 'description': description,
        if (rewardDescription != null) 'reward_description': rewardDescription,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (backgroundUrl != null) 'background_url': backgroundUrl,
        if (backgroundColor != null)
          'background_color': AppFormatters.hexCode(backgroundColor!),
        if (stampIconUrl != null) 'stamp_icon_url': stampIconUrl,
        if (category != null) 'category': category,
        'is_active': isActive,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        'customers_count': customersCount,
      };
}
