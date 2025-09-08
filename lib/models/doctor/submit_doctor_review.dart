class ReviewResponse {
  final bool status;
  final int statuscode;
  final String message;
  final ReviewData? data;

  ReviewResponse({
    required this.status,
    required this.statuscode,
    required this.message,
    this.data,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statuscode': statuscode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ReviewData {
  final String id;
  final DateTime date;
  final String doctorId;
  final String userId;
  final double rating;
  final String review;
  final bool isApproved;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String createdBy;
  final String updatedBy;

  ReviewData({
    required this.id,
    required this.date,
    required this.doctorId,
    required this.userId,
    required this.rating,
    required this.review,
    required this.isApproved,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      doctorId: json['doctorId'] ?? '',
      userId: json['userId'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] ?? '',
      isApproved: json['isApproved'] ?? false,
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'doctorId': doctorId,
      'userId': userId,
      'rating': rating,
      'review': review,
      'isApproved': isApproved,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
