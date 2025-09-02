class DoctorDetailModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final DoctorData? data;

  DoctorDetailModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      status: json['status'],
      statusCode: json['statuscode'],
      message: json['message'],
      data: json['data'] != null ? DoctorData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statuscode": statusCode,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class DoctorData {
  final String? id;
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
  final String? createdBy;
  final String? updatedBy;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final UserData? userData;
  final Creator? creator;
  final Creator? updater;
  final List<Service>? services;
  final List<Skill>? skills;
  final List<dynamic>? socials;
  final List<dynamic>? experiences;
  final List<dynamic>? qualifications;
  final List<dynamic>? recognitions;
  final String? email;
  final String? phone;

  DoctorData({
    this.id,
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
    this.createdBy,
    this.updatedBy,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userData,
    this.creator,
    this.updater,
    this.services,
    this.skills,
    this.socials,
    this.experiences,
    this.qualifications,
    this.recognitions,
    this.email,
    this.phone,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      id: json['id'],
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
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      userData:
      json['Userdata'] != null ? UserData.fromJson(json['Userdata']) : null,
      creator:
      json['Creator'] != null ? Creator.fromJson(json['Creator']) : null,
      updater:
      json['Updater'] != null ? Creator.fromJson(json['Updater']) : null,
      services: json['Services'] != null
          ? List<Service>.from(json['Services'].map((x) => Service.fromJson(x)))
          : [],
      skills: json['Skills'] != null
          ? List<Skill>.from(json['Skills'].map((x) => Skill.fromJson(x)))
          : [],
      socials: json['Socials'] ?? [],
      experiences: json['Experiences'] ?? [],
      qualifications: json['Qualifications'] ?? [],
      recognitions: json['Recognitions'] ?? [],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "name": name,
      "slug": slug,
      "title": title,
      "experience": experience,
      "specialization": specialization,
      "bio": bio,
      "description": description,
      "context_id": contextId,
      "slotDuration": slotDuration,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "userId": userId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "deletedAt": deletedAt,
      "Userdata": userData?.toJson(),
      "Creator": creator?.toJson(),
      "Updater": updater?.toJson(),
      "Services": services?.map((e) => e.toJson()).toList(),
      "Skills": skills?.map((e) => e.toJson()).toList(),
      "Socials": socials,
      "Experiences": experiences,
      "Qualifications": qualifications,
      "Recognitions": recognitions,
      "email": email,
      "phone": phone,
    };
  }
}

class UserData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  UserData({this.id, this.firstName, this.lastName, this.email, this.phone});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
    };
  }
}

class Creator {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  Creator({this.id, this.firstName, this.lastName, this.email});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
    };
  }
}

class Service {
  final String? id;
  final String? name;
  final String? description;
  final String? price;

  Service({this.id, this.name, this.description, this.price});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
    };
  }
}

class Skill {
  final String? id;
  final String? name;
  final String? description;

  Skill({this.id, this.name, this.description});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
    };
  }
}
