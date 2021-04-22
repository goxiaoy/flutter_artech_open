class TokenModel {
  TokenModel(this.token, this.expireAt, {this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      json['token'] as String,
      json['expireAt'] == null
          ? null
          : DateTime.parse(json['expireAt'] as String),
      refreshToken: json['refreshToken'] as String?,
    );
  }

  final String token;
  DateTime? expireAt;
  final String? refreshToken;

  bool isValid() {
    if (token.isEmpty) {
      return false;
    }
    if (expireAt != null) {
      return expireAt!.isAfter(DateTime.now());
    } else {
      return true;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expireAt'] = expireAt?.toUtc().toIso8601String();
    data['refreshToken'] = refreshToken;
    return data;
  }
}
