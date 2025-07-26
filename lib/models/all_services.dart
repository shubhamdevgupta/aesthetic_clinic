class ServiceResponse {
  final bool status;
  final int statuscode;
  final String message;
  final List<ServiceData> data;
  final Meta meta;

  ServiceResponse({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => ServiceData.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statuscode': statuscode,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class ServiceData {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String image;
  final String? extraDetail;
  final String parentServiceId;
  final List<SubService> subServices;
  final List<Doctor> doctors;

  ServiceData({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.extraDetail,
    required this.parentServiceId,
    required this.subServices,
    required this.doctors,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'] ?? '',
      subServices: (json['subServices'] as List)
          .map((e) => SubService.fromJson(e))
          .toList(),
      doctors:
      (json['doctors'] as List).map((e) => Doctor.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'price': price,
    'image': image,
    'extra_detail': extraDetail,
    'parentServiceId': parentServiceId,
    'subServices': subServices.map((e) => e.toJson()).toList(),
    'doctors': doctors.map((e) => e.toJson()).toList(),
  };
}

class SubService {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String image;
  final String? extraDetail;
  final String parentServiceId;

  SubService({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.extraDetail,
    required this.parentServiceId,
  });

  factory SubService.fromJson(Map<String, dynamic> json) {
    return SubService(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'price': price,
    'image': image,
    'extra_detail': extraDetail,
    'parentServiceId': parentServiceId,
  };
}

class Doctor {
  final String id;
  final String name;
  final String slug;
  final String title;
  final int experience;
  final String specialization;
  final String bio;
  final String? description;
  final int slotDuration;

  Doctor({
    required this.id,
    required this.name,
    required this.slug,
    required this.title,
    required this.experience,
    required this.specialization,
    required this.bio,
    required this.description,
    required this.slotDuration,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      experience: json['experience'] ?? 0,
      specialization: json['specialization'] ?? '',
      bio: json['bio'] ?? '',
      description: json['description'],
      slotDuration: json['slotDuration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'title': title,
    'experience': experience,
    'specialization': specialization,
    'bio': bio,
    'description': description,
    'slotDuration': slotDuration,
  };
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
  };
}
