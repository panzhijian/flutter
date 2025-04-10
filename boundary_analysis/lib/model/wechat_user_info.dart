import 'dart:convert';

class WechatUserInfo {
  final String? openid;
  final String? nickname;
  final int? sex;
  final String? language;
  final String? city;
  final String? province;
  final String? country;
  final String? headimgurl;
  final List<dynamic>? privilege;
  final String? unionid;

  WechatUserInfo({
    this.openid,
    this.nickname,
    this.sex,
    this.language,
    this.city,
    this.province,
    this.country,
    this.headimgurl,
    this.privilege,
    this.unionid,
  });

  WechatUserInfo copyWith({
    String? openid,
    String? nickname,
    int? sex,
    String? language,
    String? city,
    String? province,
    String? country,
    String? headimgurl,
    List<dynamic>? privilege,
    String? unionid,
  }) =>
      WechatUserInfo(
        openid: openid ?? this.openid,
        nickname: nickname ?? this.nickname,
        sex: sex ?? this.sex,
        language: language ?? this.language,
        city: city ?? this.city,
        province: province ?? this.province,
        country: country ?? this.country,
        headimgurl: headimgurl ?? this.headimgurl,
        privilege: privilege ?? this.privilege,
        unionid: unionid ?? this.unionid,
      );

  factory WechatUserInfo.fromRawJson(String str) => WechatUserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WechatUserInfo.fromJson(Map<String, dynamic> json) => WechatUserInfo(
    openid: json["openid"],
    nickname: json["nickname"],
    sex: json["sex"],
    language: json["language"],
    city: json["city"],
    province: json["province"],
    country: json["country"],
    headimgurl: json["headimgurl"],
    privilege: json["privilege"] == null ? [] : List<dynamic>.from(json["privilege"]!.map((x) => x)),
    unionid: json["unionid"],
  );

  Map<String, dynamic> toJson() => {
    "openid": openid,
    "nickname": nickname,
    "sex": sex,
    "language": language,
    "city": city,
    "province": province,
    "country": country,
    "headimgurl": headimgurl,
    "privilege": privilege == null ? [] : List<dynamic>.from(privilege!.map((x) => x)),
    "unionid": unionid,
  };
}
