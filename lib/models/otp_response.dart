class OtpResponseModel {
  final bool status;
  final int statuscode;
  final String message;
  final Map<String, dynamic> data;

  OtpResponseModel({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      status: json['status'] ?? false,
      statuscode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statuscode': statuscode,
      'message': message,
      'data': data,
    };
  }
}
