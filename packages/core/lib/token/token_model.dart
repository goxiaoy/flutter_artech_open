class TokenModel {
  TokenModel(this.token, this.expireAt, this.userId, {this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      json['token'] as String,
      json['expireAt'] == null
          ? null
          : DateTime.parse(json['expireAt'] as String),
      json['userId'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  final String? userId;
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
    data['userId'] = userId;
    data['token'] = token;
    data['expireAt'] = expireAt;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
