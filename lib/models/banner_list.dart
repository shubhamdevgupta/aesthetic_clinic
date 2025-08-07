class AppConfigurationResponse {
  final bool status;
  final int statuscode;
  final String message;
  final List<AppConfigData> data;
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
      data: (json['data'] as List).map((e) => AppConfigData.fromJson(e)).toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}
class AppConfigData {
  final AppConfigs appConfigs;
  final List<Service> topServices;
  final List<Service> recommendedServices;

  AppConfigData({
    required this.appConfigs,
    required this.topServices,
    required this.recommendedServices,
  });

  factory AppConfigData.fromJson(Map<String, dynamic> json) {
    return AppConfigData(
      appConfigs: AppConfigs.fromJson(json['appConfigs']),
      topServices: (json['topServices'] as List).map((e) => Service.fromJson(e)).toList(),
      recommendedServices: (json['recommendedServices'] as List).map((e) => Service.fromJson(e)).toList(),
    );
  }
}
class AppConfigs {
  final List<BannerItem> banner;
  final List<dynamic> landingPage;
  final List<dynamic> screen;
  final List<dynamic> offer;

  AppConfigs({
    required this.banner,
    required this.landingPage,
    required this.screen,
    required this.offer,
  });

  factory AppConfigs.fromJson(Map<String, dynamic> json) {
    return AppConfigs(
      banner: (json['banner'] as List).map((e) => BannerItem.fromJson(e)).toList(),
      landingPage: json['landing_page'],
      screen: json['screen'],
      offer: json['offer'],
    );
  }
}
class BannerItem {
  final String id;
  final String type;
  final ConfigData configData;
  final bool isActive;

  BannerItem({
    required this.id,
    required this.type,
    required this.configData,
    required this.isActive,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'],
      type: json['type'],
      configData: ConfigData.fromJson(json['configData']),
      isActive: json['isActive'],
    );
  }
}
class ConfigData {
  final String text;
  final String title;
  final String imageUrl;
  final String subtitle;
  final String actionUrl;

  ConfigData({
    required this.text,
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.actionUrl,
  });

  factory ConfigData.fromJson(Map<String, dynamic> json) {
    return ConfigData(
      text: json['text'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      subtitle: json['subtitle'],
      actionUrl: json['actionUrl'],
    );
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
  final String topServiceImage;
  final bool isRecommended;
  final dynamic extraDetail;
  final String? parentServiceId;
  final List<Doctor> doctors;

  Service({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.image,
    required this.isTopService,
    required this.topServiceImage,
    required this.isRecommended,
    required this.extraDetail,
    required this.parentServiceId,
    required this.doctors,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
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
      doctors: (json['doctors'] as List).map((e) => Doctor.fromJson(e)).toList(),
    );
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
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      title: json['title'],
      experience: json['experience'],
      specialization: json['specialization'],
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

