class AuthResponse {
  final AuthData? data;
  final dynamic error;

  AuthResponse({required this.data, required this.error});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'error': error,
    };
  }
}

class AuthData {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String roleId;
  final String? doctorId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    required this.roleId,
    this.doctorId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      roleId: json['roleId'],
      doctorId: json['doctorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'roleId': roleId,
      'doctorId': doctorId,
    };
  }
}
