class ServiceResponse {
  final bool status;
  final int statusCode;
  final String message;
  final List<ServiceItem> data;
  final Meta meta;

  ServiceResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      status: json['status'],
      statusCode: json['statuscode'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statuscode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class ServiceItem {
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
  final String parentServiceId;
  final List<dynamic> doctor; // You can replace with Doctor model if needed
  final List<dynamic> products; // You can replace with Product model if needed

  ServiceItem({
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
    required this.parentServiceId,
    required this.doctor,
    required this.products,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      isTopService: json['isTopService'],
      topServiceImage: json['topServiceImage'],
      isRecommended: json['isRecommended'],
      personalisedService: json['personalisedService'],
      personalisedServiceImages: json['personalisedServiceImages'],
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'],
      doctor: json['Doctor'] ?? [],
      products: json['Products'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'image': image,
      'isTopService': isTopService,
      'topServiceImage': topServiceImage,
      'isRecommended': isRecommended,
      'personalisedService': personalisedService,
      'personalisedServiceImages': personalisedServiceImages,
      'extra_detail': extraDetail,
      'parentServiceId': parentServiceId,
      'Doctor': doctor,
      'Products': products,
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
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
