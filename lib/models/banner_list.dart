import 'dart:convert';

class AppConfigurationResponse {
  final bool status;
  final int statuscode;
  final String message;
  final List<AppData> data;
  final Meta meta;

  AppConfigurationResponse({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AppConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return AppConfigurationResponse(
      status: json['status'],
      statuscode: json['statuscode'],
      message: json['message'],
      data: List<AppData>.from(json['data'].map((x) => AppData.fromJson(x))),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class AppData {
  final List<dynamic> appConfigs; // empty array, no structure yet
  final List<TopService> topServices;

  AppData({
    required this.appConfigs,
    required this.topServices,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      appConfigs: json['appConfigs'] ?? [],
      topServices: List<TopService>.from(json['topServices'].map((x) => TopService.fromJson(x))),
    );
  }
}

class TopService {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String image;
  final bool isTopService;
  final String topServiceImage;
  final bool isRecommended;
  final String? extraDetail;
  final String parentServiceId;
  final List<dynamic> doctors;

  TopService({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.isTopService,
    required this.topServiceImage,
    required this.isRecommended,
    this.extraDetail,
    required this.parentServiceId,
    required this.doctors,
  });

  factory TopService.fromJson(Map<String, dynamic> json) {
    return TopService(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      isTopService: json['isTopService'],
      topServiceImage: json['topServiceImage'],
      isRecommended: json['isRecommended'],
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'],
      doctors: json['doctors'] ?? [],
    );
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
}
