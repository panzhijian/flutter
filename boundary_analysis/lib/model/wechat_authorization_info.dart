import 'dart:convert';

class WechatAuthorizationInfo {
  final String? accessToken;
  final int? expiresIn;
  final String? refreshToken;
  final String? openid;
  final String? scope;
  final String? unionid;

  WechatAuthorizationInfo({
    this.accessToken,
    this.expiresIn,
    this.refreshToken,
    this.openid,
    this.scope,
    this.unionid,
  });

  WechatAuthorizationInfo copyWith({
    String? accessToken,
    int? expiresIn,
    String? refreshToken,
    String? openid,
    String? scope,
    String? unionid,
  }) =>
      WechatAuthorizationInfo(
        accessToken: accessToken ?? this.accessToken,
        expiresIn: expiresIn ?? this.expiresIn,
        refreshToken: refreshToken ?? this.refreshToken,
        openid: openid ?? this.openid,
        scope: scope ?? this.scope,
        unionid: unionid ?? this.unionid,
      );

  factory WechatAuthorizationInfo.fromRawJson(String str) => WechatAuthorizationInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WechatAuthorizationInfo.fromJson(Map<String, dynamic> json) => WechatAuthorizationInfo(
    accessToken: json["access_token"],
    expiresIn: json["expires_in"],
    refreshToken: json["refresh_token"],
    openid: json["openid"],
    scope: json["scope"],
    unionid: json["unionid"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "expires_in": expiresIn,
    "refresh_token": refreshToken,
    "openid": openid,
    "scope": scope,
    "unionid": unionid,
  };
}
