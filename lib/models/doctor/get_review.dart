class DoctorReview {
  final bool status;
  final int statuscode;
  final String message;
  final List<ReviewData> data;
  final Meta meta;

  DoctorReview({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory DoctorReview.fromJson(Map<String, dynamic> json) {
    return DoctorReview(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReviewData.fromJson(e))
          .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statuscode': statuscode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class ReviewData {
  final String id;
  final String doctorId;
  final String? productId;
  final String userId;
  final String rating;
  final String review;
  final bool isApproved;
  final String date;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final Reviewer reviewer;

  ReviewData({
    required this.id,
    required this.doctorId,
    this.productId,
    required this.userId,
    required this.rating,
    required this.review,
    required this.isApproved,
    required this.date,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.reviewer,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      productId: json['productId'],
      userId: json['userId'] ?? '',
      rating: json['rating'] ?? '0',
      review: json['review'] ?? '',
      isApproved: json['isApproved'] ?? false,
      date: json['date'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      deletedAt: json['deletedAt'],
      reviewer: Reviewer.fromJson(json['Reviewer'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'review': review,
      'isApproved': isApproved,
      'date': date,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt,
      'Reviewer': reviewer.toJson(),
    };
  }
}

class Reviewer {
  final String id;
  final String firstName;
  final String lastName;

  Reviewer({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
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
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
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
