class UpdateProfileResponse {
  final bool status;
  final int statuscode;
  final String message;
  final UpdateProfileData data;

  UpdateProfileResponse({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: UpdateProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statuscode": statuscode,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class UpdateProfileData {
  final String id;
  final String email;
  final String phone;
  final String? emiratesId;
  final String firstName;
  final String lastName;
  final bool isEmailVerified;
  final bool mfaEnabled;
  final String createdAt;
  final String updatedAt;

  UpdateProfileData({
    required this.id,
    required this.email,
    required this.phone,
    this.emiratesId,
    required this.firstName,
    required this.lastName,
    required this.isEmailVerified,
    required this.mfaEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      emiratesId: json['emiratesId'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      mfaEnabled: json['mfaEnabled'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "phone": phone,
      "emiratesId": emiratesId,
      "firstName": firstName,
      "lastName": lastName,
      "isEmailVerified": isEmailVerified,
      "mfaEnabled": mfaEnabled,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
