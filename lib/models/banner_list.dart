class AppConfigurationResponse {
  final bool status;
  final int statuscode;
  final String message;
  final List<DataItem> data;
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
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataItem.fromJson(e))
          .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
    "meta": meta.toJson(),
  };
}

class DataItem {
  final AppConfigs appConfigs;
  final List<Service> topServices;
  final List<Service> recommendedServices;
  final List<Service> personalisedServices;

  DataItem({
    required this.appConfigs,
    required this.topServices,
    required this.recommendedServices,
    required this.personalisedServices,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      appConfigs: AppConfigs.fromJson(json['appConfigs'] ?? {}),
      topServices: (json['topServices'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList() ??
          [],
      recommendedServices: (json['recommendedServices'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList() ??
          [],
      personalisedServices: (json['personalisedservices'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "appConfigs": appConfigs.toJson(),
    "topServices": topServices.map((e) => e.toJson()).toList(),
    "recommendedServices":
    recommendedServices.map((e) => e.toJson()).toList(),
    "personalisedservices":
    personalisedServices.map((e) => e.toJson()).toList(),
  };
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
      banner: (json['banner'] as List<dynamic>?)
          ?.map((e) => BannerItem.fromJson(e))
          .toList() ??
          [],
      landingPage: json['landing_page'] ?? [],
      screen: json['screen'] ?? [],
      offer: json['offer'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "banner": banner.map((e) => e.toJson()).toList(),
    "landing_page": landingPage,
    "screen": screen,
    "offer": offer,
  };
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
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      configData: ConfigData.fromJson(json['configData'] ?? {}),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "configData": configData.toJson(),
    "isActive": isActive,
  };
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
      text: json['text'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      subtitle: json['subtitle'] ?? '',
      actionUrl: json['actionUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "text": text,
    "title": title,
    "imageUrl": imageUrl,
    "subtitle": subtitle,
    "actionUrl": actionUrl,
  };
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
  final bool personalisedService;
  final String? personalisedServiceImages;
  final String? extraDetail;
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
    this.topServiceImage,
    required this.isRecommended,
    required this.personalisedService,
    this.personalisedServiceImages,
    this.extraDetail,
    this.parentServiceId,
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
      personalisedService: json['personalisedService'] ?? false,
      personalisedServiceImages: json['personalisedServiceImages'],
      extraDetail: json['extra_detail'],
      parentServiceId: json['parentServiceId'],
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((e) => Doctor.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
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
    "parentServiceId": parentServiceId,
    "doctors": doctors.map((e) => e.toJson()).toList(),
  };
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

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "title": title,
    "experience": experience,
    "specialization": specialization,
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
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}
