enum SocialProvider { google, apple }

final class SocialAuthRequest {
  const SocialAuthRequest({
    required this.provider,
    required this.identityToken,
    this.authorizationCode,
  });

  final SocialProvider provider;
  final String identityToken;
  final String? authorizationCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identity_token': identityToken,
        if (authorizationCode != null) 'authorization_code': authorizationCode,
      };
}
