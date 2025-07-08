class OtpResponse {
  final dynamic data;
  final String? message;
  final dynamic error;

  OtpResponse({
    required this.data,
    required this.message,
    required this.error,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      data: json['data'],
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'error': error,
    };
  }
}
