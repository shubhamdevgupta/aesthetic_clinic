class ServiceDetailResponse {
  final bool status;
  final int statuscode;
  final String message;
  final ServiceDetail data;

  ServiceDetailResponse({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: ServiceDetail.fromJson(json['data'] ?? {}),
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

class ServiceDetail {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String image;
  final bool isTopService;
  final String? topServiceImage;
  final bool isRecommended;
  final bool personalisedService;
  final String? personalisedServiceImages;
  final String? extraDetail;
  final String? contextId;
  final String? parentServiceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<Doctor> doctors;
  final List<Product> products;

  ServiceDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.isTopService,
    this.topServiceImage,
    required this.isRecommended,
    required this.personalisedService,
    this.personalisedServiceImages,
    this.extraDetail,
    this.contextId,
    this.parentServiceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.doctors,
    required this.products,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      image: json['image'] ?? '',
      isTopService: json['isTopService'] ?? false,
      topServiceImage: json['topServiceImage'],
      isRecommended: json['isRecommended'] ?? false,
      personalisedService: json['personalisedService'] ?? false,
      personalisedServiceImages: json['personalisedServiceImages'],
      extraDetail: json['extra_detail'],
      contextId: json['context_id'],
      parentServiceId: json['parentServiceId'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
      doctors: (json['Doctors'] as List<dynamic>?)
          ?.map((e) => Doctor.fromJson(e))
          .toList() ??
          [],
      products: (json['Products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
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
      "personalisedService": personalisedService,
      "personalisedServiceImages": personalisedServiceImages,
      "extra_detail": extraDetail,
      "context_id": contextId,
      "parentServiceId": parentServiceId,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "deletedAt": deletedAt?.toIso8601String(),
      "Doctors": doctors.map((e) => e.toJson()).toList(),
      "Products": products.map((e) => e.toJson()).toList(),
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

  Doctor({
    required this.id,
    required this.name,
    required this.slug,
    required this.title,
    required this.experience,
    required this.specialization,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      experience: json['experience'] ?? 0,
      specialization: json['specialization'] ?? '',
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
    };
  }
}

class Product {
  final String? id;
  final String? name;

  Product({this.id, this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
