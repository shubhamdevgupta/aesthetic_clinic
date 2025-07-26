class LoginResponseModel {
  final bool status;
  final int statuscode;
  final String message;
  final LoginData data;

  LoginResponseModel({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statuscode': statuscode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final User user;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
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
  final String? emiratesId;
  final String roleId;
  final String? doctorId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    this.emiratesId,
    required this.roleId,
    this.doctorId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      emiratesId: json['emiratesId'],
      roleId: json['roleId'] ?? '',
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
      'emiratesId': emiratesId,
      'roleId': roleId,
      'doctorId': doctorId,
    };
  }
}
