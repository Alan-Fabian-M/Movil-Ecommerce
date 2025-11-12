class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isStaff;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.isStaff = false,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      isStaff: json['is_staff'] ?? false,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_staff': isStaff,
      'is_active': isActive,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
      user: User.fromJson(json['user']),
    );
  }
}
