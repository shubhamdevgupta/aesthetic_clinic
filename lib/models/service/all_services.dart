class GetAllService {
  final bool status;
  final int statuscode;
  final String message;
  final List<Service> data;
  final Meta meta;

  GetAllService({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory GetAllService.fromJson(Map<String, dynamic> json) {
    return GetAllService(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statuscode": statuscode,
      "message": message,
      "data": data.map((e) => e.toJson()).toList(),
      "meta": meta.toJson(),
    };
  }
}

class Service {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String image;
  final bool isTopService;
  final String? topServiceImage;
  final bool isRecommended;
  final String? extraDetail;
  final String? parentServiceId;
  final List<SubService> subServices;
  final List<Doctor> doctors;

  Service({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.isTopService,
    this.topServiceImage,
    required this.isRecommended,
    this.extraDetail,
    this.parentServiceId,
    required this.subServices,
    required this.doctors,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      image: json['image'] ?? '',
      isTopService: json['isTopService'] ?? false,
      topServiceImage: json['topServiceImage'],
      isRecommended: json['isRecommended'] ?? false,
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'],
      subServices: (json['subServices'] as List<dynamic>?)
          ?.map((e) => SubService.fromJson(e))
          .toList() ??
          [],
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((e) => Doctor.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "slug": slug,
      "description": description,
      "price": price,
      "image": image,
      "isTopService": isTopService,
      "topServiceImage": topServiceImage,
      "isRecommended": isRecommended,
      "extra_detail": extraDetail,
      "parentServiceId": parentServiceId,
      "subServices": subServices.map((e) => e.toJson()).toList(),
      "doctors": doctors.map((e) => e.toJson()).toList(),
    };
  }
}

class SubService {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String image;
  final bool isTopService;
  final String? topServiceImage;
  final bool isRecommended;
  final String? extraDetail;
  final String? parentServiceId;

  SubService({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.isTopService,
    this.topServiceImage,
    required this.isRecommended,
    this.extraDetail,
    this.parentServiceId,
  });

  factory SubService.fromJson(Map<String, dynamic> json) {
    return SubService(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      image: json['image'] ?? '',
      isTopService: json['isTopService'] ?? false,
      topServiceImage: json['topServiceImage'],
      isRecommended: json['isRecommended'] ?? false,
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "slug": slug,
      "description": description,
      "price": price,
      "image": image,
      "isTopService": isTopService,
      "topServiceImage": topServiceImage,
      "isRecommended": isRecommended,
      "extra_detail": extraDetail,
      "parentServiceId": parentServiceId,
    };
  }
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
    this.description,
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "slug": slug,
      "title": title,
      "experience": experience,
      "specialization": specialization,
      "bio": bio,
      "description": description,
      "slotDuration": slotDuration,
    };
  }
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
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total": total,
      "page": page,
      "limit": limit,
      "totalPages": totalPages,
    };
  }
}
