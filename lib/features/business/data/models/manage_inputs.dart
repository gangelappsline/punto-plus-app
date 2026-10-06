import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Datos capturados en el formulario de tarjetas del negocio.
final class LoyaltyCardInput {
  const LoyaltyCardInput({
    required this.name,
    required this.requiredStamps,
    this.description,
    this.rewardDescription,
    this.backgroundColor,
    this.isActive = true,
    this.logoUrl,
    this.backgroundUrl,
    this.stampIconUrl,
  });

  final String name;
  final int requiredStamps;
  final String? description;
  final String? rewardDescription;
  final Color? backgroundColor;
  final bool isActive;
  final String? logoUrl;
  final String? backgroundUrl;
  final String? stampIconUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name.trim(),
        'required_stamps': requiredStamps,
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        if (rewardDescription != null && rewardDescription!.trim().isNotEmpty)
          'reward_description': rewardDescription!.trim(),
        if (backgroundColor != null)
          'background_color': AppFormatters.hexCode(backgroundColor!),
        'is_active': isActive,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (backgroundUrl != null) 'background_url': backgroundUrl,
        if (stampIconUrl != null) 'stamp_icon_url': stampIconUrl,
      };
}

/// Datos capturados en el formulario de promociones del negocio.
final class PromotionInput {
  const PromotionInput({
    required this.title,
    this.description,
    this.startsAt,
    this.endsAt,
    this.isActive = true,
    this.imageUrl,
  });

  final String title;
  final String? description;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final String? imageUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title.trim(),
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        if (startsAt != null) 'starts_at': startsAt!.toIso8601String(),
        if (endsAt != null) 'ends_at': endsAt!.toIso8601String(),
        'is_active': isActive,
        if (imageUrl != null) 'image_url': imageUrl,
      };
}
