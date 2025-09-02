class DoctorResponse {
  final bool status;
  final int statuscode;
  final String message;
  final List<Doctor> data;
  final Meta meta;

  DoctorResponse({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory DoctorResponse.fromJson(Map<String, dynamic> json) {
    return DoctorResponse(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Doctor.fromJson(e))
          .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class Doctor {
  final String id;
  final String? image;
  final String? name;
  final String? slug;
  final String? title;
  final int? experience;
  final String? specialization;
  final String? bio;
  final String? description;
  final String? contextId;
  final int? slotDuration;
  final UserData? userdata;
  final Creator? creator;
  final Creator? updater;
  final List<Service> services;
  final List<Skill> skills;
  final List<dynamic> socials;
  final List<dynamic> experiences;
  final List<dynamic> qualifications;
  final List<dynamic> recognitions;
  final String? email;
  final String? phone;

  Doctor({
    required this.id,
    this.image,
    this.name,
    this.slug,
    this.title,
    this.experience,
    this.specialization,
    this.bio,
    this.description,
    this.contextId,
    this.slotDuration,
    this.userdata,
    this.creator,
    this.updater,
    required this.services,
    required this.skills,
    required this.socials,
    required this.experiences,
    required this.qualifications,
    required this.recognitions,
    this.email,
    this.phone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      image: json['image'],
      name: json['name'],
      slug: json['slug'],
      title: json['title'],
      experience: json['experience'],
      specialization: json['specialization'],
      bio: json['bio'],
      description: json['description'],
      contextId: json['context_id'],
      slotDuration: json['slotDuration'],
      userdata: json['Userdata'] != null
          ? UserData.fromJson(json['Userdata'])
          : null,
      creator:
      json['Creator'] != null ? Creator.fromJson(json['Creator']) : null,
      updater:
      json['Updater'] != null ? Creator.fromJson(json['Updater']) : null,
      services: (json['Services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList() ??
          [],
      skills: (json['Skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e))
          .toList() ??
          [],
      socials: json['Socials'] ?? [],
      experiences: json['Experiences'] ?? [],
      qualifications: json['Qualifications'] ?? [],
      recognitions: json['Recognitions'] ?? [],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class UserData {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  UserData({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class Creator {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;

  Creator({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}

class Service {
  final String id;
  final String? name;
  final String? description;
  final String? price;

  Service({
    required this.id,
    this.name,
    this.description,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}

class Skill {
  final String id;
  final String? name;
  final String? description;

  Skill({
    required this.id,
    this.name,
    this.description,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
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
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
