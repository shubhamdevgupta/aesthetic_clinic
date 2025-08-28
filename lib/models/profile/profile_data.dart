class ProfileResponse {
  final bool status;
  final int statusCode;
  final String message;
  final ProfileData? data;

  ProfileResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      statusCode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statuscode': statusCode,
    'message': message,
    'data': data?.toJson(),
  };
}

class ProfileData {
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
  final dynamic userDetail;
  final Role? role;
  final dynamic kyc;

  ProfileData({
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
    this.userDetail,
    this.role,
    this.kyc,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      emiratesId: json['emiratesId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      mfaEnabled: json['mfaEnabled'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userDetail: json['UserDetail'],
      role: json['Role'] != null ? Role.fromJson(json['Role']) : null,
      kyc: json['kyc'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phone': phone,
    'emiratesId': emiratesId,
    'firstName': firstName,
    'lastName': lastName,
    'isEmailVerified': isEmailVerified,
    'mfaEnabled': mfaEnabled,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'UserDetail': userDetail,
    'Role': role?.toJson(),
    'kyc': kyc,
  };
}

class Role {
  final String id;
  final String name;
  final String description;
  final List<Permission> permissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      permissions: (json['Permissions'] as List<dynamic>?)
          ?.map((e) => Permission.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'Permissions': permissions.map((e) => e.toJson()).toList(),
  };
}

class Permission {
  final String id;
  final String name;
  final String description;
  final RolePermission? rolePermission;

  Permission({
    required this.id,
    required this.name,
    required this.description,
    this.rolePermission,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rolePermission: json['RolePermissions'] != null
          ? RolePermission.fromJson(json['RolePermissions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'RolePermissions': rolePermission?.toJson(),
  };
}

class RolePermission {
  final String createdAt;
  final String updatedAt;
  final String permissionId;
  final String roleId;

  RolePermission({
    required this.createdAt,
    required this.updatedAt,
    required this.permissionId,
    required this.roleId,
  });

  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      permissionId: json['permissionId'],
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'permissionId': permissionId,
    'roleId': roleId,
  };
}
