class OtpRequestModel {
  final String contact;
  final String otp;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isVerified;

  OtpRequestModel({
    required this.contact,
    required this.otp,
    required this.createdAt,
    required this.expiresAt,
    this.isVerified = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory OtpRequestModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestModel(
      contact: json['contact'] ?? '',
      otp: json['otp'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact,
      'otp': otp,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_verified': isVerified,
    };
  }

  OtpRequestModel copyWith({
    String? contact,
    String? otp,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isVerified,
  }) {
    return OtpRequestModel(
      contact: contact ?? this.contact,
      otp: otp ?? this.otp,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}